extends HBoxContainer

signal energy_consumed

@onready var energy_bar = $EnergyBar
@onready var energy_label = $EnergyLabel
@onready var entanglements = %Entanglements
@onready var gain_energy_button = %GainEnergyButton
@onready var energy_button_bar = %EnergyButtonBar
@onready var ions = %Ions

var energy: float
var max_energy: float
var energy_depleted = false
var _energy_consumed = 0

var button_energy_gain = 0.0
var button_energy_gain_time = 0.0
const max_button_energy_time = 3.0
var stat_button_energy_gain = 1.0

func _ready():
    max_energy = 10
    energy = max_energy
    update_ui()
    entanglements.entanglement_bought.connect(entanglement_bought)
    gain_energy_button.hide()
    gain_energy_button.pressed.connect(_on_gain_energy_button_pressed)

func get_energy_gain():
    var energy_gain = 0.0
    if entanglements.is_bought(Registries.ENTANGLE_ENERGY_CHARGE_1):
        energy_gain += Registries.ENTANGLE_ENERGY_CHARGE_1.get_meta("increase")
    if entanglements.is_bought(Registries.ENTANGLE_ENERGY_CHARGE_2):
        energy_gain += Registries.ENTANGLE_ENERGY_CHARGE_2.get_meta("increase")
    energy_gain *= 1 + (ions.get_ion_boost(Registries.ION_CHARGE) / 100.0)
    return energy_gain

func entanglement_bought(entanglement):
    if entanglement == Registries.ENTANGLE_MAX_ENERGY_1:
        max_energy += Registries.ENTANGLE_MAX_ENERGY_1.get_meta("increase")
    if entanglement == Registries.ENTANGLE_ENERGIZE_AMOUNT_1:
        stat_button_energy_gain += Registries.ENTANGLE_ENERGIZE_AMOUNT_1.get_meta("increase")

func consume(amount):
    energy -= amount
    _energy_consumed += amount
    energy_consumed.emit()
    if energy <= 0:
        energy = 0
        energy_depleted = true
    if _energy_consumed >= 5:
        gain_energy_button.show()
    update_ui()

func _physics_process(delta):
    if energy < max_energy:
        energy += delta * (get_energy_gain() + button_energy_gain)
        if energy > max_energy:
            energy = max_energy
        update_ui()
    if energy_depleted and energy >= max_energy:
        energy_depleted = false

    button_energy_gain_time -= delta
    energy_button_bar.value = button_energy_gain_time
    if button_energy_gain_time <= 0.0:
        button_energy_gain = 0.0

func update_ui():
    energy_bar.max_value = max_energy
    energy_bar.value = energy
    energy_label.text = Utils.format_number(energy)
    energy_button_bar.max_value = max_button_energy_time
    gain_energy_button.disabled = button_energy_gain_time > 0.0

func _on_gain_energy_button_pressed():
    button_energy_gain = stat_button_energy_gain
    button_energy_gain_time = max_button_energy_time

func save_data(data):
    data["energy"] = energy
    data["max_energy"] = max_energy
    data["energy_consumed"] = _energy_consumed
    data["button_energy_gain"] = button_energy_gain
    data["button_energy_gain_time"] = button_energy_gain_time
    data["stat_button_energy_gain"] = stat_button_energy_gain

func load_data(data):
    energy = data["energy"]
    max_energy = data["max_energy"]
    _energy_consumed = data.get("energy_consumed", 0)
    button_energy_gain = data.get("button_energy_gain", 0.0)
    button_energy_gain_time = data.get("button_energy_gain_time", 0.0)
    stat_button_energy_gain = data.get("stat_button_energy_gain", 1.0)
    update_ui()
    if _energy_consumed >= 5:
        gain_energy_button.show()

func is_energy_depleted() -> bool:
    return energy_depleted
