extends PanelContainer

signal unlock_bought

const UNLOCK = preload("res://unlock.tscn")
const EMPTY_UNLOCK = preload("res://empty_unlock.tscn")

@onready var unlocks_container = $VBoxContainer/MarginContainer/UnlocksContainer

func _ready():
    var i = 0
    for unlock in Registries.unlocks:
        i += 1
        var new_unlock = UNLOCK.instantiate()
        new_unlock.def = unlock
        new_unlock.unlock_bought.connect(func(): unlock_bought.emit())
        unlocks_container.add_child(new_unlock)

    for _j in range(i, 8):
        var new_unlock = EMPTY_UNLOCK.instantiate()
        unlocks_container.add_child(new_unlock)
