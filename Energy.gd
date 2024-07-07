extends HBoxContainer

@onready var energy_bar = $EnergyBar
@onready var energy_label = $EnergyLabel

var energy: float
var max_energy: float
var energy_gain: float

func _ready():
    energy_gain = 0.5
    max_energy = 10
    energy =  max_energy
    update_ui()

func consume(amount):
    energy -= amount
    update_ui()

func _physics_process(delta):
    if energy < max_energy:
        energy += delta * energy_gain
        update_ui()

func update_ui():
    energy_bar.max_value = max_energy
    energy_bar.value = energy
    energy_label.text = Utils.format_number(energy)
