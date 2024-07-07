extends Node

const UNLOCK_UPGRADES = preload("res://data/unlocks/unlock_upgrades.tres")

const unlocks = [
    UNLOCK_UPGRADES
]

var ids_to_unlocks: Dictionary

func _ready():
    for unlock in unlocks:
        ids_to_unlocks[unlock.id] = unlock
