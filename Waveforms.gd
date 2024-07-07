extends HBoxContainer

@onready var world = %World
@onready var waveforms_label = $WaveformsLabel

var waveforms: float

func _ready():
    world.successful_dodge.connect(dodge)
    waveforms_label.text = Utils.format_number(waveforms)

func dodge():
    waveforms += 1
    waveforms_label.text = Utils.format_number(waveforms)

