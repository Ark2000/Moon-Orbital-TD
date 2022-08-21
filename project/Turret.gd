extends Node2D

const rotation_speed = 4.0

#dependencies
var bullet_prefab = preload("res://Bullet4.tscn")
onready var timer = $Timer
onready var barrel = $Barrel2
onready var spawn_location = $Barrel2/Barrel/SpawnLocation
onready var anim_player = $AnimationPlayer
onready var detector = $Detector
onready var target_indicator = $TargetIndicator
onready var range_hint = $RangeHint

export var bullet_speed = D.turret_base_bullet_speed
var b20 = 0
var barrels = 1
var damage = D.turret_base_damage
var explode_radius = 0
var homing_ability = 0


var _global_velocity
var _last_position
var _target
var _enemies = {}
var selected = false

func _ready():
	detector.connect("area_entered", self, "_on_detector_entered")
	detector.connect("area_exited", self, "_on_detector_exited")
	
	_last_position = global_position
	_global_velocity = Vector2.ZERO
	
	set_fire_rate(D.turret_base_fire_rate)

func _on_detector_entered(a):
	if a.has_meta("owner"):
		_enemies[a.get_meta("owner")] = 0

func _on_detector_exited(a):
	if a.has_meta("owner"):
		_enemies.erase(a.get_meta("owner"))
		if _target == a.get_meta("owner"):
			_target = null

func look_at_pos(pos, delta):
		var target_rotation = pos - global_position
		var current_rotation = Vector2.RIGHT.rotated(barrel.rotation)
		var difference = current_rotation.angle_to(target_rotation)
		if abs(difference) < rotation_speed * delta:
			barrel.rotation += difference
		else:
			barrel.rotation += sign(difference) * rotation_speed * delta

		current_rotation = Vector2.RIGHT.rotated(barrel.rotation)
		difference = current_rotation.angle_to(target_rotation)
		return abs(difference)
func _physics_process(delta):
	_global_velocity = (global_position - _last_position) / delta
	_last_position = global_position

	if selected:
		look_at_pos(get_global_mouse_position(), delta)
		if Input.is_action_pressed("click"):
			shoot()
	#autopilot
	else:
		if _target:
			var dir = aim_predict(_target.global_position, _target.linear_velocity - _global_velocity, spawn_location.global_position, bullet_speed)
			var diff = look_at_pos(global_position + dir, delta)
			if diff < 0.01:
				shoot()
			target_indicator.show()
			target_indicator.global_position = _target.global_position
		else:
			if !_enemies.empty():
				var e = _enemies.keys()
				_target = e[randi() % e.size()]
			target_indicator.hide()

func get_fire_rate():
	return 1.0 / timer.wait_time

func set_fire_rate(v):
	timer.wait_time = 1.0 / v

func shoot():
	if b20 <= 0: return
	if !timer.is_stopped():
		return
	timer.start()
	anim_player.stop()
	anim_player.play("shoot", -1, anim_player.get_animation("shoot").length / timer.wait_time)

	var sp = -12 * (barrels - 1) / 2
	var sr = -0.1 * (barrels - 1) / 2
	for i in range(barrels):
		var bullet = bullet_prefab.instance()
		bullet.damage = damage
		bullet.position = spawn_location.global_position + Vector2.RIGHT.rotated(barrel.rotation + PI / 2) * sp
		bullet.rotation = barrel.rotation + sr
		bullet.speed = bullet_speed
		bullet.initial_vel = _global_velocity
		bullet.homing = homing_ability
		bullet.explode_r = explode_radius
		get_tree().current_scene.add_child(bullet)
		sp += 12
		sr += 0.1

func aim_predict(target_pos:Vector2, target_velocity:Vector2, bullet_pos:Vector2, bullet_speed:float, bullet_accel := 0.0, target_accel := 0.0) -> Vector2:
	var t:float
	var p2 := target_pos
	for i in 10:
		t = _get_t((p2 - bullet_pos).length(), bullet_speed, bullet_accel)
		p2 = target_pos + target_velocity * t + 0.5 * t * t * target_velocity.normalized() * target_accel
	return (p2 - bullet_pos).normalized()

func _get_t(l:float, v:float, a:float) -> float:
	if a == 0.0: return l / v
	var d = sqrt(v * v + 2 * a * l)
	return max((-v + d) / a, (-v - d) / a)
