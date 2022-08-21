extends Node2D

const eee = preload("EEE.tscn")

func _ready():
	Engine.time_scale = 1.0

func _on_Timer_timeout():
	var e = eee.instance()
	e.position = Vector2(-1000, rand_range(-400, 400))
	e.v = Vector2(400, rand_range(-100, 100))
	add_child(e)

func _input(_e):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to(preload("res://launch.tscn"))
