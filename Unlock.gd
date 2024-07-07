extends PanelContainer

signal unlock_bought

@onready var title = %Title
@onready var description = %Description
@onready var cost_label = %CostLabel
@onready var unlock_button = %UnlockButton

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
