extends Node2D

#dependencies
onready var area2d = $Area2D
onready var detector = $Detector
const effect_prefab = preload("res://DestroyEffect1.tscn")

export var speed:float
export var initial_vel:Vector2
var damage = 30.0
var homing = 0
var explode_r = 0

var vel
var accel
var max_vel

var _target

func _ready():
	area2d.set_meta("damage", damage)
	vel = initial_vel + Vector2.RIGHT.rotated(rotation) * speed
	max_vel = vel.length()
	accel = Vector2.ZERO

func _physics_process(delta):
	vel += accel * delta
	vel = vel.clamped(max_vel)
	position += vel * delta
	rotation = vel.angle()
	
	if G.is_valid_node(_target):
		if _target.has_meta("owner") and homing > 1.0:
			#homing

			# more accurate
#			var d = _target.global_position - global_position
#			var t = d.length() / max_vel
#			var np = _target.global_position + _target.get_meta("owner").linear_velocity * t
#			var nd = np - global_position
#			accel = ((nd.normalized() * max_vel - vel) / 0.1).clamped(homing)
			# more efficient
			var nd = _target.global_position - global_position
			accel = ((nd.normalized() * max_vel - vel) / 0.1).clamped(homing)
	else:
		if detector.areas.size() > 0:
			_target = detector.areas.keys()[0]

func _on_Area2D_area_entered(area):
	self_destroy()

func _on_Timer_timeout():
	self_destroy()

func self_destroy():
	if explode_r > 0:
		var e = G.spawn_explosion02(global_position)
		e.scale = Vector2.ONE * explode_r / 100.0
		e.damage = damage

	var effect = effect_prefab.instance()
	effect.position = position
	effect.rotation = randf() * TAU
	get_tree().current_scene.add_child(effect)
	queue_free()
