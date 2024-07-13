class_name DimensionDef extends Resource

@export var id: String
@export var name: String
@export_multiline var description: String
@export var cost: float
@export var collision_cooldown = 2.0
@export var num_collisions = 1
@export var lines: Array[Line]
