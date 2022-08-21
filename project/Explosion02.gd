extends Area2D

var damage = 30.0

func _ready() -> void:
	set_meta("damage", damage)

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()

