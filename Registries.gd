extends Node

const UNLOCK_DIMENSIONS = preload("res://data/unlocks/unlock_dimensions.tres")
const UNLOCK_ENTANGLEMENTS = preload("res://data/unlocks/unlock_entanglements.tres")
const UNLOCK_IONS = preload("res://data/unlocks/unlock_ions.tres")

const unlocks = [
    UNLOCK_DIMENSIONS,
    UNLOCK_ENTANGLEMENTS,
    UNLOCK_IONS
]

const DIMENSION_1 = preload("res://data/dimensions/dimension_1.tres")
const DIMENSION_2 = preload("res://data/dimensions/dimension_2.tres")
const DIMENSION_3 = preload("res://data/dimensions/dimension_3.tres")
const DIMENSION_4 = preload("res://data/dimensions/dimension_4.tres")

const dimensions = [
    DIMENSION_1,
    DIMENSION_2,
    DIMENSION_3,
    DIMENSION_4
]

const ENTANGLE_MAX_ENERGY_1 = preload("res://data/entanglements/entangle_max_energy_1.tres")
const ENTANGLE_ENERGY_CHARGE_1 = preload("res://data/entanglements/entangle_energy_charge_1.tres")
const ENTANGLE_ENERGIZE_AMOUNT_1 = preload("res://data/entanglements/entangle_energize_amount_1.tres")

const entanglements = [
    ENTANGLE_MAX_ENERGY_1,
    ENTANGLE_ENERGY_CHARGE_1,
    ENTANGLE_ENERGIZE_AMOUNT_1
]

const ION_CHARGE = preload("res://data/ions/ion_charge.tres")

const ions = [
    ION_CHARGE
]

var ids_to_unlocks: Dictionary
var ids_to_dimensions: Dictionary
var ids_to_entanglements: Dictionary
var ids_to_ions: Dictionary

func _ready():
    for unlock in unlocks:
        ids_to_unlocks[unlock.id] = unlock

    for dimension in dimensions:
        ids_to_dimensions[dimension.id] = dimension

    for entangle in entanglements:
        ids_to_entanglements[entangle.id] = entangle

    for ion in ions:
        ids_to_ions[ion.id] = ion
