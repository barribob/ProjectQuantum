extends Button

const RAPID_PRESS_INTERVAL = 0.4
const LONG_PRESS_DURATION = 0.5

@onready var neutrons = %Neutrons

var long_press_timer: Timer
var is_long_press: bool = false
var long_press_time: float
var rapid_press_time: float

func _ready():
    long_press_timer = Timer.new()
    long_press_timer.one_shot = true
    long_press_timer.wait_time = LONG_PRESS_DURATION
    add_child(long_press_timer)

    long_press_timer.timeout.connect(_on_long_press_timeout)
    button_down.connect(_on_button_pressed)
    button_up.connect(_on_button_released)

func _on_button_pressed():
    long_press_timer.start()

func _on_button_released():
    long_press_timer.stop()
    is_long_press = false

func _on_long_press_timeout():
    is_long_press = true
    long_press_time = 0
    rapid_press_time = 0

func disable():
    disabled = true
    _on_button_released()

func _process(delta):
    if is_long_press:
        long_press_time += delta
        rapid_press_time += delta
        var rapid_press_scaling = RAPID_PRESS_INTERVAL - min(RAPID_PRESS_INTERVAL * 0.8, long_press_time / 5.0)
        if rapid_press_time >= rapid_press_scaling:
            rapid_press_time = 0
            emit_signal("pressed")
