extends PanelContainer

signal unlock_bought

@onready var title = %Title
@onready var description = %Description
@onready var cost_label = %CostLabel
@onready var unlock_button = %UnlockButton

const UNLOCK_BOUGHT = preload("res://unlock_bought.tres")

var def: UnlockDef
var bought: bool

func _ready():
    title.text = def.name
    description.text = def.description
    cost_label.text = Utils.format_number(def.cost)
    CurrentRun.waveforms.waveforms_updated.connect(update_ui)
    unlock_button.pressed.connect(_on_unlock_button_pressed)
    update_ui()

func _on_unlock_button_pressed():
    bought = true
    CurrentRun.waveforms.consume(def.cost)
    unlock_bought.emit()
    update_ui()

func update_ui():
    var cant_afford = def.cost > CurrentRun.waveforms.waveforms
    unlock_button.disabled = cant_afford || bought

    if bought and unlock_button.text != "Unlocked":
        unlock_button.add_theme_stylebox_override("disabled", UNLOCK_BOUGHT)
        unlock_button.disabled = true
        unlock_button.text = "Unlocked"

func save_data(data):
    data["bought"] = bought

func load_data(data):
    if data.has("bought"):
        bought = data["bought"]
    update_ui()
