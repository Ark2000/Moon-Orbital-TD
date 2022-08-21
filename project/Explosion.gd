extends Node2D

onready var anim_player = $AnimationPlayer

func _ready() -> void:
	$Sprite.rotation = randf() * TAU
	anim_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
