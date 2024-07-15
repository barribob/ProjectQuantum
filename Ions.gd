class_name Ions extends PanelContainer

signal ions_updated

@onready var buy_ion_button = %BuyIonButton
@onready var buy_ion_cost = %BuyIonCost
@onready var waveforms = %Waveforms
@onready var ions_position = %IonsPosition
@onready var ions_container = %IonsContainer

const ION_VISUAL = preload("res://ion_visual.tscn")
const ION = preload("res://ion.tscn")

var ions: int = 0
var ion_visuals = []
var ion_uis = []
var get_by_def = {}

func _ready():
    update_ui()
    buy_ion_button.pressed.connect(_on_buy_ion_button_pressed)
    waveforms.waveforms_updated.connect(update_ui)

    for ion in Registries.ions:
        var ion_instance = ION.instantiate()
        ion_instance.def = ion
        ion_instance.ions = self
        ion_instance.ions_updated.connect(func(): ions_updated.emit())
        ions_container.add_child(ion_instance)
        ion_uis.append(ion_instance)
        get_by_def[ion] = ion_instance

func _on_buy_ion_button_pressed():
    CurrentRun.waveforms.consume(get_buy_ion_cost())
    ions += 1
    update_ui()

func get_buy_ion_cost():
    return pow(5, get_ions_everywhere()) * 50

func get_ions_everywhere():
    return ions + ion_uis.reduce(func(a, v): return a + v.ions_assigned, 0.0)

func update_ui():
    buy_ion_button.disabled = get_buy_ion_cost() > CurrentRun.waveforms.waveforms
    buy_ion_cost.text = Utils.format_number(get_buy_ion_cost())

func display():
    show()

    var tween = create_tween()
    var time = 0.07
    for ion_ui in ion_uis:
        ion_ui.modulate.a = 0.0
        tween.tween_property(ion_ui, "modulate:a", 1.0, time)

func claim_ion():
    ions -= 1
    return ion_visuals.pop_back()

func return_ion(visual):
    ions += 1
    ion_visuals.append(visual)

func _process(delta):
    while ion_visuals.size() < ions:
        var visual = ION_VISUAL.instantiate()
        ions_position.add_child(visual)
        ion_visuals.append(visual)

    var circle_positions = Utils.generate_circle_positions(ions, 50)

    for i in range(ions):
        ion_visuals[i].position = lerp(ion_visuals[i].position, circle_positions[i], delta)

func get_ion_boost(ion):
    return get_by_def[ion].get_boost_value()

func save_data(data):
    data["ions"] = ions
    data["ion_uis"] = {}
    for ion in ion_uis:
        var ion_data = {}
        ion.save_data(ion_data)
        data["ion_uis"][ion.def.id] = ion_data

func load_data(data):
    ions = data["ions"]
    for id in data["ion_uis"]:
        var def = Registries.ids_to_ions[id]
        if get_by_def.has(def):
            get_by_def[def].load_data(data["ion_uis"][id])
    update_ui()
