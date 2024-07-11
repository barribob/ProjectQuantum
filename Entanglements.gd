extends PanelContainer

signal entanglement_bought(def)

@onready var buttons_container = %ButtonsContainer
@onready var entanglement_description_label = %EntanglementDescriptionLabel
@onready var entanglement_name = %EntanglementName
@onready var entanglement_cost = %EntanglementCost
@onready var entanglement_cost_label = %EntanglementCostLabel
@onready var origin = %Origin

const ENTANGLEMENT = preload("res://entanglement.tscn")
const EMPTY_ENTANGLEMENT = preload("res://empty_entanglement.tscn")

var get_by_def = {}
var entanglements = []

func _ready():
    var i = 0
    for entanglement in Registries.entanglements:
        var new_entanglement = ENTANGLEMENT.instantiate()
        new_entanglement.def = entanglement
        new_entanglement.position = buttons_container.get_child(i).position
        new_entanglement.mouse_entered_fr.connect(mouse_entered.bind(new_entanglement))
        new_entanglement.mouse_exited_fr.connect(clear_description)
        new_entanglement.entanglement_bought.connect(func(): entanglement_bought.emit(entanglement))
        i+=1
        buttons_container.add_child(new_entanglement)
        get_by_def[entanglement] = new_entanglement
        entanglements.append(new_entanglement)

    entanglement_cost.visible = false

func mouse_entered(entanglement):
    entanglement_description_label.text = Utils.apply_tags(entanglement.def.description, entanglement.def)
    entanglement_name.text = entanglement.def.name
    entanglement_cost_label.text = Utils.format_number(entanglement.def.cost)
    entanglement_cost.visible = true

func clear_description():
    entanglement_description_label.text = ""
    entanglement_name.text = ""
    entanglement_cost.visible = false

func save_data(data):
    data["entanglements"] = {}
    for entanglement in entanglements:
        var entanglement_data = {}
        entanglement.save_data(entanglement_data)
        data["entanglements"][entanglement.def.id] = entanglement_data

func load_data(data):
    for id in data["entanglements"]:
        var def = Registries.ids_to_entanglements[id]
        if get_by_def.has(def):
            get_by_def[def].load_data(data["entanglements"][id])

func display():
    show()
    var tween = create_tween()
    tween.set_parallel()
    var time = 0.1
    for entanglement in entanglements:
        entanglement.modulate.a = 0.0
        var original_position = entanglement.position
        var offset_direction = (origin.position - entanglement.position).normalized().rotated(PI/2)
        entanglement.position = original_position + offset_direction * 50
        tween.tween_property(entanglement, "position", original_position, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
        tween.tween_property(entanglement, "modulate:a", 1.0, time)
