extends Node2D

#dependencies
onready var area2d = $Area2D
const effect_prefab = preload("res://DestroyEffect1.tscn")

export var speed:float
export var initial_vel:Vector2
export var accel:float
var damage = 30.0

func _ready():
	area2d.set_meta("damage", damage)

func _physics_process(delta):
	position += (speed * Vector2.RIGHT.rotated(rotation) + initial_vel) * delta
	speed += accel * delta

func _on_Area2D_area_entered(area):
	self_destroy()

func _on_Timer_timeout():
	self_destroy()

func self_destroy():
	queue_free()
	var effect = effect_prefab.instance()
	effect.position = position
	effect.rotation = randf() * TAU
	get_tree().current_scene.add_child(effect)
