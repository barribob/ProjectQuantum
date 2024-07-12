extends PanelContainer

signal switch_dimension

@onready var name_label = $MarginContainer/HBoxContainer/NameLabel
@onready var description_label = $MarginContainer/HBoxContainer/DescriptionLabel
@onready var cost_label = %CostLabel
@onready var unlock_button = %UnlockButton
@onready var switch_button = $MarginContainer/HBoxContainer/SwitchButton
@onready var cost_ui = %CostUI

var def: DimensionDef
var selected: bool = false
var unlocked: bool = false

func _ready():
    name_label.text = def.name
    description_label.text = def.description
    cost_label.text = Utils.format_number(def.cost)
    unlock_button.pressed.connect(_on_unlock_button_pressed)
    switch_button.pressed.connect(_on_switch_button_pressed)
    CurrentRun.waveforms.waveforms_updated.connect(update_ui)
    update_ui()

func _on_unlock_button_pressed():
    CurrentRun.waveforms.consume(def.cost)
    unlocked = true
    switch_dimension.emit()
    update_ui()

func _on_switch_button_pressed():
    switch_dimension.emit()

func update_ui():
    switch_button.disabled = selected
    switch_button.visible = unlocked
    var cant_afford = def.cost > CurrentRun.waveforms.waveforms
    unlock_button.disabled = cant_afford
    cost_ui.visible = !unlocked
    switch_button.text = "Selected" if selected else "Switch"

func save_data(data):
    data["unlocked"] = unlocked
    data["selected"] = selected

func load_data(data):
    unlocked = data["unlocked"]
    selected = data["selected"]
    update_ui()
