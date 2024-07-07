extends Sprite2D

var fade_time = 0.2

func _ready():
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, fade_time)
    tween.tween_callback(queue_free)
