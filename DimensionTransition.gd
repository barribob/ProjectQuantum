extends ColorRect

@onready var dimensions: PanelContainer = %Dimensions

func _ready() -> void:
    hide()
    dimensions.switch_dimension.connect(_switch_dimension)

func _switch_dimension() -> void:
    modulate.a = 1.0
    show()
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, 0.2)
