extends Label

func _ready():
    hide()
    Console.add_command("fps", show)

func _process(_delta):
    text = "%1.0f" % Engine.get_frames_per_second()
