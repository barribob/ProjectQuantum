extends Node

signal finished

@onready var energy = %Energy
@onready var tutorial_panel = %TutorialPanel
@onready var tutorial_panel_2 = %TutorialPanel2
@onready var tutorial_panel_3 = %TutorialPanel3
@onready var tutorial_panel_4 = %TutorialPanel4
@onready var tutorial_panel_5 = %TutorialPanel5

var tutorial_finished = false

func _ready():
    await get_tree().process_frame
    await get_tree().process_frame
    if not tutorial_finished:
        tutorial_panel.display()
        tutorial_panel.ok_clicked.connect(_on_tutorial_ok_clicked)

func _on_tutorial_ok_clicked():
    tutorial_panel_2.display()
    tutorial_panel_2.ok_clicked.connect(_on_tutorial_ok_clicked_2)

func _on_tutorial_ok_clicked_2():
    tutorial_panel_3.display()
    tutorial_panel_3.ok_clicked.connect(_on_tutorial_ok_clicked_3)

func _on_tutorial_ok_clicked_3():
    tutorial_panel_4.display()
    energy.gain_energy_button.pressed.connect(_on_gain_energy_button_pressed)

func _on_gain_energy_button_pressed():
    energy.gain_energy_button.pressed.disconnect(_on_gain_energy_button_pressed)
    tutorial_panel_5.display()
    tutorial_panel_5.ok_clicked.connect(_on_tutorial_ok_clicked_5)

func _on_tutorial_ok_clicked_5():
    tutorial_finished = true
    finished.emit()

func save_data(data):
    data["tutorial_finished"] = tutorial_finished

func load_data(data):
    tutorial_finished = data["tutorial_finished"]
    if tutorial_finished:
        finished.emit()
