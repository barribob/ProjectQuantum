extends Node

const UNLOCK_DIMENSIONS = preload("res://data/unlocks/unlock_dimensions.tres")

const unlocks = [
    UNLOCK_DIMENSIONS
]

const DIMENSION_1 = preload("res://data/dimensions/dimension_1.tres")
const DIMENSION_2 = preload("res://data/dimensions/dimension_2.tres")

const dimensions = [
    DIMENSION_1,
    DIMENSION_2
]

var ids_to_unlocks: Dictionary
var ids_to_dimensions: Dictionary

func _ready():
    for unlock in unlocks:
        ids_to_unlocks[unlock.id] = unlock

    for dimension in dimensions:
        ids_to_dimensions[dimension.id] = dimension
