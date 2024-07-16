extends HBoxContainer

signal ok_clicked

@onready var label = $Label
@onready var button = $Button

func _ready():
    hide()
    button.pressed.connect(func():
        hide()
        ok_clicked.emit())

func display():
    modulate.a = 0
    var original_position = position
    position.y += 20
    var tween = create_tween()
    tween.set_parallel()
    tween.tween_property(self, "modulate:a", 1.0, 0.3)
    tween.tween_property(self, "position", original_position, 0.3)
    show()
