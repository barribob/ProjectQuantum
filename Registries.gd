extends Node

const UNLOCK_DIMENSIONS = preload("res://data/unlocks/unlock_dimensions.tres")
const UNLOCK_ENTANGLEMENTS = preload("res://data/unlocks/unlock_entanglements.tres")

const unlocks = [
    UNLOCK_DIMENSIONS,
    UNLOCK_ENTANGLEMENTS
]

const DIMENSION_1 = preload("res://data/dimensions/dimension_1.tres")
const DIMENSION_2 = preload("res://data/dimensions/dimension_2.tres")

const dimensions = [
    DIMENSION_1,
    DIMENSION_2
]

const ENTANGLE_MAX_ENERGY_1 = preload("res://data/entanglements/entangle_max_energy_1.tres")
const ENTANGLE_ENERGY_CHARGE_1 = preload("res://data/entanglements/entangle_energy_charge_1.tres")
const ENTANGLE_ENERGIZE_AMOUNT_1 = preload("res://data/entanglements/entangle_energize_amount_1.tres")

const entanglements = [
    ENTANGLE_MAX_ENERGY_1,
    ENTANGLE_ENERGY_CHARGE_1,
    ENTANGLE_ENERGIZE_AMOUNT_1
]

var ids_to_unlocks: Dictionary
var ids_to_dimensions: Dictionary
var ids_to_entanglements: Dictionary

func _ready():
    for unlock in unlocks:
        ids_to_unlocks[unlock.id] = unlock

    for dimension in dimensions:
        ids_to_dimensions[dimension.id] = dimension

    for entangle in entanglements:
        ids_to_entanglements[entangle.id] = entangle
