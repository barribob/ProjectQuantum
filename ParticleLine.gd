extends Line2D

var fade_time = 0.3

func _ready():
    var tween = create_tween()
    tween.set_parallel()
    tween.tween_property(self, "modulate:a", 0.0, fade_time)
    tween.tween_property(self, "width", 0.0, fade_time)
    tween.tween_callback(queue_free).set_delay(fade_time)
