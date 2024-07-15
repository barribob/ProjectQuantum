extends PanelContainer

@onready var fusion_progress_bar = %FusionProgressBar
@onready var nuclei_container = %NucleiContainer
@onready var nucleus_title = %NucleusTitle
@onready var nucleus_description = %NucleusDescription
@onready var equip_button = %EquipButton
@onready var upgrade_button = %UpgradeButton
@onready var recycle_button = %RecycleButton
@onready var nuclei_equip = %NucleiEquip
@onready var unequip_button = %UnequipButton
@onready var nuclei_equip_label = %NucleiEquipLabel

const NUCLEUS = preload("res://nucleus.tscn")

var current_selected_nucleus = null

var fusion_progress = 0.0
const max_equipped_nuclei = 3
const max_fusion_progress = 1.0
var nuclei = []
var equipped_nuclei = []

func _ready():
    fusion_progress_bar.max_value = max_fusion_progress
    fusion_progress_bar.step = 0.001
    nucleus_title.text = ""
    nucleus_description.text = ""
    equip_button.visible = false
    upgrade_button.visible = false
    recycle_button.visible = false
    unequip_button.visible = false
    equip_button.pressed.connect(equip_nucleus)
    unequip_button.pressed.connect(unequip_nucleus)
    update_equip_ui()

func unequip_nucleus():
    if current_selected_nucleus:
        nuclei_equip.remove_child(current_selected_nucleus)
        nuclei_container.add_child(current_selected_nucleus)
        equipped_nuclei.erase(current_selected_nucleus)
        nuclei.append(current_selected_nucleus)
        update_description(current_selected_nucleus)
        update_equip_ui()

func equip_nucleus():
    if current_selected_nucleus:
        nuclei_container.remove_child(current_selected_nucleus)
        nuclei_equip.add_child(current_selected_nucleus)
        equipped_nuclei.append(current_selected_nucleus)
        nuclei.erase(current_selected_nucleus)
        update_description(current_selected_nucleus)
        update_equip_ui()

func _physics_process(delta):
    fusion_progress += delta * 0.05
    if fusion_progress >= max_fusion_progress:
        fusion_progress = 0
        var nucleus = generate_nucleus(pick_random_nucleus())
    fusion_progress_bar.value = fusion_progress

func generate_nucleus(def):
    var nucleus = NUCLEUS.instantiate()
    nucleus.def = def
    nucleus.selected.connect(nucleus_selected.bind(nucleus))
    nuclei_container.add_child(nucleus)
    nuclei.append(nucleus)
    return nucleus

func nucleus_selected(nucleus):
    if current_selected_nucleus:
        current_selected_nucleus.set_deselected()
    current_selected_nucleus = nucleus
    update_description(nucleus)

func update_equip_ui():
    nuclei_equip_label.text = "Equip Nuclei %s/%s" % [equipped_nuclei.size(), max_equipped_nuclei]

func update_description(nucleus):
    nucleus_title.text = nucleus.def.name
    nucleus_description.text = Utils.apply_tags_instance(nucleus.def.description, nucleus.def, nucleus)
    equip_button.visible = not equipped_nuclei.has(nucleus)
    equip_button.disabled = max_equipped_nuclei <= equipped_nuclei.size()
    unequip_button.visible = equipped_nuclei.has(nucleus)
    upgrade_button.visible = true
    recycle_button.visible = true
    current_selected_nucleus.set_selected()

func pick_random_nucleus():
    return Registries.nuclei[randi() % Registries.nuclei.size()]

func display():
    show()

func save_data(data):
    data["fusion_progress"] = fusion_progress
    data["nuclei"] = []
    for nucleus in nuclei:
        var nucleus_data = { "id": nucleus.def.id }
        nucleus.save_data(nucleus_data)
        data["nuclei"].append(nucleus_data)
    data["equipped_nuclei"] = []
    for nucleus in equipped_nuclei:
        var nucleus_data = { "id": nucleus.def.id }
        nucleus.save_data(nucleus_data)
        data["equipped_nuclei"].append(nucleus_data)

func load_data(data):
    fusion_progress = data["fusion_progress"]
    for nucleus_data in data["nuclei"]:
        var def = Registries.ids_to_nuclei[nucleus_data["id"]]
        var nucleus = generate_nucleus(def)
        nucleus.load_data(nucleus_data)
    for nucleus_data in data.get("equipped_nuclei", []):
        var def = Registries.ids_to_nuclei[nucleus_data["id"]]
        var nucleus = generate_nucleus(def)
        current_selected_nucleus = nucleus
        equip_nucleus()
        nucleus.load_data(nucleus_data)
