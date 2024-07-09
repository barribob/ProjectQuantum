extends HBoxContainer

@onready var energy_bar = $EnergyBar
@onready var energy_label = $EnergyLabel
@onready var entanglements = %Entanglements

var energy: float
var max_energy: float
var energy_gain: float

func _ready():
    energy_gain = 0.5
    max_energy = 10
    energy =  max_energy
    update_ui()

    entanglements.entanglement_bought.connect(entanglement_bought)

func entanglement_bought(entanglement):
    if entanglement == Registries.ENTANGLE_MAX_ENERGY_1:
        max_energy += Registries.ENTANGLE_MAX_ENERGY_1.get_meta("increase")
    if entanglement == Registries.ENTANGLE_ENERGY_CHARGE_1:
        energy_gain += Registries.ENTANGLE_ENERGY_CHARGE_1.get_meta("increase")

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

func save_data(data):
    data["energy"] = energy
    data["max_energy"] = max_energy
    data["energy_gain"] = energy_gain

func load_data(data):
    energy = data["energy"]
    max_energy = data["max_energy"]
    energy_gain = data["energy_gain"]
    update_ui()
