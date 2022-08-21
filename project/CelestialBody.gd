class_name CelestiaBody
extends KinematicBody2D

const GRAVITATIONAL_CONSTANT = 10000.0

export var mass:float
export var initial_velocity:Vector2
var current_velocity:Vector2

func _ready():
	current_velocity = initial_velocity

func update_velocity(all_bodies, time_step):
	for other_body in all_bodies:
		if other_body != self:
			var sqr_dst = (other_body.global_position - global_position).length_squared()
			var force_dir = (other_body.global_position - global_position).normalized()
			var force = force_dir * GRAVITATIONAL_CONSTANT * mass * other_body.mass / sqr_dst
			var acceleration = force / mass
			current_velocity += acceleration * time_step

func update_position(time_step):
	current_velocity = move_and_slide(current_velocity)


#################################################################################################3
#用于模拟
class Data:
	var mass:float
	var velocity:Vector2
	var position:Vector2

	func update_velocity(all_data, time_step):
		for other_data in all_data:
			if other_data != self:
				var sqr_dst = (other_data.position - position).length_squared()
				var force_dir = (other_data.position - position).normalized()
				var force = force_dir * GRAVITATIONAL_CONSTANT * mass * other_data.mass / sqr_dst
				var acceleration = force / mass
				velocity += acceleration * time_step

	func update_position(time_step):
		position += velocity * time_step
