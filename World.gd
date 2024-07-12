extends Node2D

@onready var energy = %Energy
@onready var dimensions = %Dimensions
@onready var animation_player = $Particle/AnimationPlayer
signal successful_dodge(dodge_value: float)
const AFTERIMAGE = preload("res://afterimage.tscn")
const PARTICLE_LINE = preload("res://particle_line.tscn")
@onready var particle = $Particle
@onready var world_no_bloom = %WorldNoBloom

var collision_cooldown = 2.0
var collision_time = collision_cooldown
var num_collisions = 1
var collisions_enabled = true
var curve = 0.0
var line_color = Color.WHITE
var dodge_value = 1.0

func _ready():
    dimensions.switch_dimension.connect(switch_dimension)
    animation_player.play("undissolve")

func switch_dimension():
    var current_dimension = dimensions.get_current_dimension()

    if current_dimension == Registries.DIMENSION_1:
        collision_cooldown = 2.0
        num_collisions = 1
        curve = 0.0
        line_color = Colors.line
        dodge_value = 1.0
    elif current_dimension == Registries.DIMENSION_2:
        collision_cooldown = 0.5
        num_collisions = 1
        curve = 0.0
        line_color = Colors.line
        dodge_value = 1.0
    elif current_dimension == Registries.DIMENSION_3:
        collision_cooldown = 0.2
        num_collisions = 1
        curve = 0.0
        line_color = Colors.line
        dodge_value = 1.0
    elif current_dimension == Registries.DIMENSION_4:
        collision_cooldown = 0.2
        num_collisions = 1
        curve = 0.5
        line_color = Colors.line_1
        dodge_value = 2.0

    collision_time = collision_cooldown

func _process(delta):
    if not collisions_enabled:
        if energy.energy >= energy.max_energy:
            collisions_enabled = true
            animation_player.play("undissolve")
        return

    collision_time -= delta
    if collision_time <= 0.0:
        collision_time = collision_cooldown
        for i in range(num_collisions):
            if Utils.geq(energy.energy, 1):
                energy.consume(1)
                create_collision(true, curve)
            else:
                collisions_enabled = false
                animation_player.play("dissolve")
                create_collision(false, curve)
                break

func create_collision(is_successful: bool, curvature: float = 0.0):
    var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
    var particle_line = PARTICLE_LINE.instantiate()
    var points = []
    var offset = particle.global_position

    # Calculate points for the curved line
    var num_points = 50 # Increase for smoother curves
    for i in range(num_points + 1):
        var t = float(i) / num_points
        var distance = lerp(-1500.0, 1500.0, t)
        var perpendicular = direction.rotated(PI/2)
        var curve_offset = perpendicular * curvature * cos(PI * t) * distance
        var point = direction * distance + curve_offset + offset
        points.append(point)

    particle_line.points = points
    particle_line.default_color = line_color  # Set the line color
    add_child(particle_line)

    if is_successful:
        var afterimage = AFTERIMAGE.instantiate()
        afterimage.position = particle.global_position
        world_no_bloom.add_child(afterimage)
        particle.position = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(32, 100)
        successful_dodge.emit(dodge_value)

func save_data(data):
    data["num_collisions"] = num_collisions
    data["collisions_enabled"] = collisions_enabled
    data["collision_cooldown"] = collision_cooldown
    data["collision_time"] = collision_time
    data["curve"] = curve
    data["line_color"] = line_color
    data["dodge_value"] = dodge_value

func load_data(data):
    num_collisions = data["num_collisions"]
    collisions_enabled = data["collisions_enabled"]
    collision_cooldown = data["collision_cooldown"]
    collision_time = data["collision_time"]
    curve = data.get("curve", 0.0)
    line_color = data.get("line_color", Colors.line)
    dodge_value = data.get("dodge_value", 1.0)
    if not collisions_enabled:
        animation_player.play("hide_instantly")
