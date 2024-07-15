class_name Nucleus extends VBoxContainer

signal selected

@onready var button = $Button
@onready var fade_in_panel = %FadeInPanel
@onready var selected_panel = %SelectedPanel
@onready var level_label = $LevelLabel
@onready var visual_position = %VisualPosition

const HOLLOW_CIRCLE = preload("res://hollow_circle.tscn")

var def: NucleusDef
var level: int
var fade_time: float = 1.0

func _ready():
    selected_panel.hide()
    fade_in_panel.show()
    var tween = create_tween()
    tween.tween_property(fade_in_panel, "modulate:a", 0, fade_time)
    button.pressed.connect(func(): selected.emit())
    level = 1
    var circle_positions = Utils.generate_circle_positions(def.visual_circles, 10)
    for i in def.visual_circles:
        var circle = HOLLOW_CIRCLE.instantiate()
        circle.modulate = def.visual_color
        circle.position = circle_positions[i]
        visual_position.add_child(circle)

    update_ui()

func update_ui():
    level_label.text = "Lv. %s" % Utils.format_number(level)

func set_selected():
    selected_panel.show()

func set_deselected():
    selected_panel.hide()

func is_selected():
    return selected_panel.visible

func get_level():
    return level

func save_data(data):
    data["level"] = level

func load_data(data):
    level = data["level"]
    update_ui()
