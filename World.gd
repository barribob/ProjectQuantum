extends Node2D

@onready var energy = %Energy
@onready var dimensions = %Dimensions
@onready var animation_player = $Particle/AnimationPlayer
signal successful_dodge(dodge_value: float)
const AFTERIMAGE = preload("res://afterimage.tscn")
const PARTICLE_LINE = preload("res://particle_line.tscn")
@onready var particle = $Particle
@onready var lines = %Lines
@onready var afterimages = %Afterimages
@onready var fusion = %Fusion

var collision_time = Registries.DIMENSION_1.collision_cooldown
var collisions_enabled = true
var current_dimension: DimensionDef

func _ready():
    dimensions.switch_dimension.connect(switch_dimension)
    current_dimension = Registries.DIMENSION_1
    animation_player.play("undissolve")

func switch_dimension():
    current_dimension = dimensions.get_current_dimension()
    collision_time = current_dimension.collision_cooldown

func _process(delta):
    if not collisions_enabled:
        if energy.energy >= energy.get_max_energy():
            collisions_enabled = true
            animation_player.play("undissolve")
        return

    collision_time -= delta
    if collision_time <= 0.0:
        collision_time = current_dimension.collision_cooldown
        for i in range(current_dimension.num_collisions):
            var line = current_dimension.lines.pick_random()
            var energy_usage = get_dodge_energy_usage(line)
            if Utils.geq(energy.energy, energy_usage):
                energy.consume(energy_usage)
                create_collision(true, line, i)
            else:
                energy.consume(energy_usage)
                collisions_enabled = false
                animation_player.play("dissolve")
                create_collision(false, line, i)
                break

func get_dodge_energy_usage(line):
    var value = line.dodge_value
    for nucleus in fusion.equipped_nuclei:
        if nucleus.def == Registries.NUCLEUS_B:
            var reduction_factor =  1 + Registries.NUCLEUS_B.get_meta("reduction") * nucleus.level
            value /= reduction_factor
    return value

func create_collision(is_successful: bool, line_properties, collision_number):
    var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
    var particle_line = PARTICLE_LINE.instantiate()
    var points = []
    var offset = particle.global_position

    var num_points = 50
    for i in range(num_points + 1):
        var t = float(i) / num_points
        var distance = lerp(-1500.0, 1500.0, t)
        var perpendicular = direction.rotated(PI/2)
        var curve_offset = perpendicular * line_properties.curve * cos(PI * t) * distance
        var point = direction * distance + curve_offset + offset
        points.append(point)

    particle_line.points = points
    particle_line.default_color = line_properties.color
    lines.add_child(particle_line)

    if is_successful:
        var afterimage = AFTERIMAGE.instantiate()
        afterimage.position = particle.global_position
        afterimage.modulate = lerp(Colors.afterimage, Colors.particle, float(collision_number) / 10.0)
        afterimages.add_child(afterimage)
        particle.position = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(32, 100)
        successful_dodge.emit(line_properties.dodge_value)

func save_data(data):
    data["collisions_enabled"] = collisions_enabled
    data["collision_time"] = collision_time
    data["current_dimension"] = current_dimension.id

func load_data(data):
    collisions_enabled = data["collisions_enabled"]
    collision_time = data["collision_time"]
    if data.has("current_dimension"):
        current_dimension = Registries.ids_to_dimensions[data["current_dimension"]]
    if not collisions_enabled:
        animation_player.play("hide_instantly")
