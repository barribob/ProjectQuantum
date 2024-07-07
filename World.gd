extends Node2D

@onready var energy = %Energy

signal successful_dodge()

const AFTERIMAGE = preload("res://afterimage.tscn")
const PARTICLE_LINE = preload("res://particle_line.tscn")
@onready var particle = $Particle

var collision_cooldown = 3.0
var collision_time = collision_cooldown
var num_collisions = 1

func _process(delta):
    collision_time -= delta

    if collision_time <= 0.0:
        collision_time = collision_cooldown
        for i in range(num_collisions):

            if energy.energy > 1:
                energy.consume(1)
            else:
                print("destroyed!")

            var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
            var particle_line = PARTICLE_LINE.instantiate()
            var offset = particle.global_position
            particle_line.add_point(direction * 1500 + offset)
            particle_line.add_point(direction * -1500 + offset)
            add_child(particle_line)

            #var afterimage = AFTERIMAGE.instantiate()
            #afterimage.global_position = particle.global_position
            #add_child(afterimage)

            particle.position = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(32, 100)
            successful_dodge.emit()
