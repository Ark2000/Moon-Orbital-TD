class_name Enemy
extends Node2D

onready var hitbox = $HitBox
onready var hurtbox = $Hurtbox
onready var detector = $Detector
onready var sprite = $Sprite
onready var death_timer = $Timer

var max_linear_velocity = D.enemy_base_speed
var max_angular_velocity = 3.0
var max_linear_acceleration = 2000.0
var max_angular_acceleraiton = 9.0

var linear_velocity = Vector2.ZERO
var linear_acceleration = Vector2.ZERO
var angular_velocity = 0.0
var angular_acceleration = 0.0
var damage = D.enemy_base_damage
var full_hp = D.enemy_base_hp
var hp

var state = "state_idle"

func _ready():
	hitbox.connect("area_entered", self, "_on_hitbox_entered")
	hurtbox.connect("area_entered", self, "_on_hurtbox_entered")
	hurtbox.set_meta("owner", self)
	hitbox.set_meta("damage", damage)
	death_timer.connect("timeout", self, "_on_death_timer_timeout")
	
	hp = full_hp
	
	G.enemies[self] = 0
	
#	print($Detector/CollisionShape2D.shape.radius)

func _on_death_timer_timeout():
	self_destroy()
	
func state_idle(_d):
	if detector.areas.size() > 0:
		var area = detector.areas.keys()[0]
		if area.has_meta("owner"):
			var target = area.get_meta("owner")
			linear_acceleration = (target.global_position - global_position).normalized() * max_linear_acceleration
			state = "state_rush"

func state_rush(_d):
	pass
	
func self_destroy():
	G.enemies.erase(self)
	queue_free()
	G.emit_signal("enemy_dead")
	G.spawn_explosion_se(global_position)
	if G.marks.has(self):
		G.marks.erase(self)

func _on_hitbox_entered(_a):
	self_destroy()

func _on_hurtbox_entered(a):
	if a.has_meta("damage"):
		hp -= a.get_meta("damage")
		if hp <= 0:
			self_destroy()

func _physics_process(delta):
	call(state, delta)
	
	sprite.rotate(2.0 * delta)
	
	linear_velocity = (linear_velocity + linear_acceleration * delta).clamped(max_linear_velocity)
	position += linear_velocity * delta
	angular_velocity = min(max_angular_velocity, angular_acceleration * delta)
	rotation += angular_velocity * delta
