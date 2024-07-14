extends PanelContainer

signal ions_updated()

var def: IonDef
var ions: Ions

@onready var assign_button = %AssignButton
@onready var unassign_button = %UnassignButton
@onready var unlock_button = %UnlockButton
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var progress_bar = %ProgressBar
@onready var unlock_ui = %UnlockUI
@onready var cost_label = %CostLabel
@onready var ion_origin = $IonOrigin

var unlocked = false
var ions_assigned = 0
var ion_visuals = []
var level = 0

func _ready():
    update_ui()
    CurrentRun.waveforms.waveforms_updated.connect(update_ui)
    ions.ions_updated.connect(update_ui)
    unlock_button.pressed.connect(_on_unlock_button_pressed)
    assign_button.pressed.connect(_on_assign_button_pressed)
    unassign_button.pressed.connect(_on_unassign_button_pressed)
    progress_bar.max_value = 1

func _on_assign_button_pressed():
    var ion = ions.claim_ion()
    ion_visuals.append(ion)
    ions_assigned += 1
    ions_updated.emit()

func _on_unassign_button_pressed():
    ions.return_ion(ion_visuals.pop_back())
    ions_assigned -= 1
    ions_updated.emit()

func _on_unlock_button_pressed():
    CurrentRun.waveforms.consume(def.unlock_cost)
    unlocked = true
    update_ui()

func update_ui():
    title_label.text = def.name
    description_label.text = get_description()
    assign_button.visible = unlocked
    unassign_button.visible = unlocked
    unlock_button.disabled = def.unlock_cost > CurrentRun.waveforms.waveforms
    unlock_ui.visible = not unlocked
    cost_label.text = Utils.format_number(def.unlock_cost)
    assign_button.disabled = ions.ions <= 0
    unassign_button.disabled = ions_assigned <= 0

func _process(delta):
    while ion_visuals.size() < ions_assigned:
        var visual = ions.ION_VISUAL.instantiate()
        ions.ions_position.add_child(visual)
        ion_visuals.append(visual)

    var circle_positions = ions.generate_circle_positions(ions_assigned, 35)

    for i in range(ions_assigned):
        ion_visuals[i].global_position = lerp(ion_visuals[i].global_position, circle_positions[i] + ion_origin.global_position, delta)

    progress_bar.value += delta * ions_assigned
    if progress_bar.value >= progress_bar.max_value:
        level += 1
        progress_bar.value = 0
        description_label.text = get_description()

func get_description():
    return "%s%%" % def.description.replace("<value>", Utils.format_number(get_boost_value()))

func get_boost_value():
    return level * def.value_per_level

func save_data(data):
    data["unlocked"] = unlocked
    data["ions_assigned"] = ions_assigned
    data["level"] = level

func load_data(data):
    unlocked = data["unlocked"]
    ions_assigned = data["ions_assigned"]
    level = data.get("level", 0)
    update_ui()
