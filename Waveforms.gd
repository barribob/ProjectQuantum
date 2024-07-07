extends HBoxContainer

signal waveforms_updated

@onready var world = %World
@onready var waveforms_label = $WaveformsLabel

var waveforms: float

func _ready():
    Console.add_command("v", func(v): add_waveforms(float(v)), 1)
    CurrentRun.waveforms = self
    world.successful_dodge.connect(dodge)
    waveforms_label.text = Utils.format_number(waveforms)

func dodge():
    add_waveforms(1)

func add_waveforms(amt):
    waveforms += amt
    waveforms_updated.emit()
    waveforms_label.text = Utils.format_number(waveforms)

func consume(amount):
    waveforms -= amount
    waveforms_updated.emit()
    waveforms_label.text = Utils.format_number(waveforms)
