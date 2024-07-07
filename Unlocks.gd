extends PanelContainer

signal unlock_bought

const UNLOCK = preload("res://unlock.tscn")
const EMPTY_UNLOCK = preload("res://empty_unlock.tscn")

@onready var unlocks_container = $VBoxContainer/MarginContainer/UnlocksContainer

var unlocks = []
var get_by_def = {}

func _ready():
    var i = 0
    for unlock in Registries.unlocks:
        i += 1
        var new_unlock = UNLOCK.instantiate()
        new_unlock.def = unlock
        new_unlock.unlock_bought.connect(func(): unlock_bought.emit())
        unlocks_container.add_child(new_unlock)
        unlocks.append(new_unlock)
        get_by_def[new_unlock.def] = new_unlock

    for _j in range(i, 8):
        var new_unlock = EMPTY_UNLOCK.instantiate()
        unlocks_container.add_child(new_unlock)

func is_unlocked(unlock):
    return get_by_def.has(unlock) and get_by_def[unlock].bought

func save_data(data):
    data["unlocks"] = {}
    for unlock in unlocks:
        var unlock_data = {}
        unlock.save_data(unlock_data)
        data["unlocks"][unlock.def.id] = unlock_data

func load_data(data):
    for id in data["unlocks"]:
        var def = Registries.ids_to_unlocks[id]
        if get_by_def.has(def):
            get_by_def[def].load_data(data["unlocks"][id])
