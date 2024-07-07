extends PanelContainer

signal unlock_bought

const UNLOCK = preload("res://unlock.tscn")
const EMPTY_UNLOCK = preload("res://empty_unlock.tscn")

@onready var unlocks_container = $VBoxContainer/MarginContainer/UnlocksContainer

var unlocks = []

func _ready():
    var i = 0
    for unlock in Registries.unlocks:
        i += 1
        var new_unlock = UNLOCK.instantiate()
        new_unlock.def = unlock
        new_unlock.unlock_bought.connect(func(): unlock_bought.emit())
        unlocks_container.add_child(new_unlock)
        unlocks.append(new_unlock)

    for _j in range(i, 8):
        var new_unlock = EMPTY_UNLOCK.instantiate()
        unlocks_container.add_child(new_unlock)

func save_data(data):
    data["unlocks"] = []
    for unlock in unlocks:
        var unlock_data = {}
        unlock_data["id"] = unlock.def.id
        unlock.save_data(unlock_data)
        data["unlocks"].append(unlock_data)

func load_data(data):
    for unlock in unlocks:
        if unlock.def.id in data:
            unlock.load_data(data[unlock.def.id])
