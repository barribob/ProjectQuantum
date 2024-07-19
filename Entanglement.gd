extends Control

signal entanglement_bought
signal mouse_entered_fr
signal mouse_exited_fr

const ENTANGLEMENT_BOUGHT = preload("res://entanglement_bought.tres")

@onready var button = $Button

var def: EntanglementDef
var bought: bool = false
var was_theme_changed = false

func _ready():
    button.text = def.name
    CurrentRun.waveforms.waveforms_updated.connect(update_ui)
    button.mouse_entered.connect(func(): mouse_entered_fr.emit())
    button.mouse_exited.connect(func(): mouse_exited_fr.emit())
    button.pressed.connect(pressed)
    update_ui()

func pressed():
    bought = true
    CurrentRun.waveforms.consume(def.cost)
    entanglement_bought.emit()
    update_ui()

func update_ui():
    if bought:
        if not was_theme_changed:
            button.add_theme_stylebox_override("disabled", ENTANGLEMENT_BOUGHT)
            button.add_theme_color_override("font_disabled_color", Color.BLACK)
            button.disabled = true
            was_theme_changed = true
    else:
        button.disabled = def.cost > CurrentRun.waveforms.waveforms

func save_data(data):
    data["bought"] = bought

func load_data(data):
    bought = data["bought"]
    update_ui()
