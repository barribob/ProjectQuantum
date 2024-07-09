extends HBoxContainer

@onready var energy_bar = $EnergyBar
@onready var energy_label = $EnergyLabel
@onready var entanglements = %Entanglements
@onready var gain_energy_button = %GainEnergyButton

var energy: float
var max_energy: float
var energy_gain: float
var energy_depleted = false
var energy_consumed = 0

var button_energy_gain = 0.0
var button_energy_gain_time = 0.0

func _ready():
    energy_gain = 0.0
    max_energy = 10
    energy = max_energy
    update_ui()
    entanglements.entanglement_bought.connect(entanglement_bought)
    gain_energy_button.hide()
    gain_energy_button.pressed.connect(_on_gain_energy_button_pressed)

func entanglement_bought(entanglement):
    if entanglement == Registries.ENTANGLE_MAX_ENERGY_1:
        max_energy += Registries.ENTANGLE_MAX_ENERGY_1.get_meta("increase")
    if entanglement == Registries.ENTANGLE_ENERGY_CHARGE_1:
        energy_gain += Registries.ENTANGLE_ENERGY_CHARGE_1.get_meta("increase")

func consume(amount):
    energy -= amount
    energy_consumed += amount
    if energy <= 0:
        energy = 0
        energy_depleted = true
    if energy_consumed >= 5:
        gain_energy_button.show()
    update_ui()

func _physics_process(delta):
    if energy < max_energy:
        energy += delta * (energy_gain + button_energy_gain)
        if energy > max_energy:
            energy = max_energy
        update_ui()
    if energy_depleted and energy >= max_energy:
        energy_depleted = false

    button_energy_gain_time -= delta
    if button_energy_gain_time <= 0.0:
        button_energy_gain = 0.0
        finish_energy_restoration()

func update_ui():
    energy_bar.max_value = max_energy
    energy_bar.value = energy
    energy_label.text = Utils.format_number(energy)

func _on_gain_energy_button_pressed():
    gain_energy_button.disabled = true
    button_energy_gain = 1.0
    button_energy_gain_time = 3.0

func finish_energy_restoration():
    gain_energy_button.disabled = false

func save_data(data):
    data["energy"] = energy
    data["max_energy"] = max_energy
    data["energy_gain"] = energy_gain
    data["energy_consumed"] = energy_consumed
    data["button_energy_gain"] = button_energy_gain
    data["button_energy_gain_time"] = button_energy_gain_time

func load_data(data):
    energy = data["energy"]
    max_energy = data["max_energy"]
    energy_gain = data["energy_gain"]
    energy_consumed = data.get("energy_consumed", 0)
    button_energy_gain = data.get("button_energy_gain", 0.0)
    button_energy_gain_time = data.get("button_energy_gain_time", 0.0)
    update_ui()
    if energy_consumed >= 5:
        gain_energy_button.show()

func is_energy_depleted() -> bool:
    return energy_depleted
