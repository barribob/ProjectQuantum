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

func dodge(value):
    add_waveforms(value)

func add_waveforms(amt):
    waveforms += amt
    waveforms_updated.emit()
    update_ui()

func consume(amount):
    waveforms -= amount
    waveforms_updated.emit()
    update_ui()

func update_ui():
    waveforms_label.text = Utils.format_number(waveforms)

func save_data(data):
    data["waveforms"] = waveforms

func load_data(data):
    waveforms = data["waveforms"]
    waveforms_updated.emit()
    update_ui()
