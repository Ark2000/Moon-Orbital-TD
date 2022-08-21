extends Node2D

export var v:Vector2

func _physics_process(delta):
	position += v * delta

func _on_Timer_timeout():
	queue_free()
