extends HBoxContainer

@onready var unlocks = %Unlocks
@onready var neutrons_label = %NeutronsLabel

var neutrons: float

func _ready():
    hide()
    unlocks.unlock_bought.connect(unlock_bought)
    neutrons_label.text = Utils.format_number(neutrons)

func add_neutrons(amount):
    neutrons += amount
    update_ui()

func unlock_bought():
    if unlocks.is_unlocked(Registries.UNLOCK_FUSION):
        show()

func save_data(data):
    data["neutrons"] = neutrons

func load_data(data):
    neutrons = data["neutrons"]
    if unlocks.is_unlocked(Registries.UNLOCK_FUSION):
        show()
    update_ui()

func update_ui():
    neutrons_label.text = Utils.format_number(neutrons)
