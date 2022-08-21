extends Node2D

#dependencies
onready var prediction = $OrbitPrediction
onready var moon_hurtbox = $Moon/HurtBox
onready var moon_hp_progress = $CircleProgress
onready var moon_hitbox = $Moon/HitBox
onready var launch_line = $LaunchLine
onready var roam_cam = $Camera2D
onready var follow_cam = $FollowCam
onready var spawner = $Spawners
var satellite_prefab = preload("res://Satellite10.tscn")

var current_satellite
var moon_radius = 310
var moon_full_hp = D.moon_hp
var moon_hp

var state = ""

func enter_state_roam():
	for s in G.satellites:
		s.connect("selected", self, "select_satellite", [s])
	
func exit_state_roam():
	for s in G.satellites:
		s.disconnect("selected", self, "select_satellite")
		
func enter_state_select_follow():
	for s in G.satellites:
		s.connect("selected", self, "_select_follow_satellite", [s])

func state_select_follow(_d):
	G.emit_signal("select_follow_state_changed", true)
	if Input.is_action_just_pressed("right_click"):
		change_state("roam")

func exit_state_select_follow():
	G.emit_signal("select_follow_state_changed", false)
	for s in G.satellites:
		s.disconnect("selected", self, "_select_follow_satellite")

func _select_follow_satellite(s):
	if s != current_satellite:
		current_satellite.set_follow(s)
	change_state("roam")
	select_satellite(null)

var launch_type = ""

func enter_state_launch():
	launch_line.show()
	G.emit_signal("launch_state_changed", true)
	change_to_follow_cam(G.moon)
	follow_cam.zoom = Vector2.ONE * 3

func state_launch(_d):
	var m = get_global_mouse_position()
	m = m.clamped(1000.0)
	launch_line.set_point_position(1, m)
	var a = m.length() / 1000.0
	launch_line.default_color = Color(1.0, 1.0 - a, 1.0 - a)
	
	if Input.is_action_just_pressed("right_click"):
		change_to_roam_cam()
		change_state("roam")
	elif Input.is_action_just_pressed("left_click"):
		var mpos = get_local_mouse_position()
		var p = mpos.normalized() * (moon_radius + 100)
		var v = (m.length() + 200.0) * m.normalized() / 2
		spawn_satellite(p, v, launch_type, true)

func spawn_satellite(p, v, type, control):
	var satellite = satellite_prefab.instance()
	satellite.connect("dead", self, "_on_satellite_dead", [satellite])
	satellite.initial_velocity = v
	satellite.position = p
	satellite.set_type(type)
	satellite.set_buff_radius(D.buff_data[type]["radius"])
	add_child(satellite)
	G.satellites[satellite] = 0
	if control:
		select_satellite(satellite)
		change_state("roam")
		G.emit_signal("satellite_launched", type)

func exit_state_launch():
	launch_line.hide()
	G.emit_signal("launch_state_changed", false)
	
func change_state(to):
	var exit = "exit_state_" + state
	var enter = "enter_state_" + to 
	if has_method(exit):
		call(exit)
	if has_method(enter):
		call(enter)
	state = to

func _ready():
	Engine.time_scale = 1.0
	
	moon_hp = moon_full_hp
	moon_hurtbox.connect("area_entered", self, "_on_moon_hurtbox_entered")
	moon_hitbox.set_meta("damage", 1000)
	moon_hurtbox.set_meta("owner", self)
	G.moon = $Moon
	G.enemies = {}
	G.satellites = {}
	G.marks = {}
	
	G.connect("release_control", self, "_on_release_control")
	G.connect("select_follow_btn_pressed", self, "_on_select_follow_btn_pressed")
	G.connect("launch_btn_pressed", self, "_on_launch_btn_pressed")
	G.connect("satellite_fall", self, "_on_satellite_fall")
	G.connect("enemy_dead", self, "_on_enemy_dead")
	
	G.emit_signal("change_camera", roam_cam)
	
	enemy_total_amount = spawner.next_wave()
	
	spawn_satellite(Vector2(600, 0), Vector2(0, 420), "B20", false)
	
	change_state("roam")


var enemy_total_amount = 0
var enemy_death_counter = 0

func _on_enemy_dead():
	enemy_death_counter += 1
	if enemy_total_amount <= enemy_death_counter:
		enemy_total_amount = spawner.next_wave()
		enemy_death_counter = 0

func _on_satellite_fall():
	moon_hurt(D.satellite_fall_damage)

func _on_launch_btn_pressed(type):
	launch_type = type
	change_state("launch")

func _on_select_follow_btn_pressed():
	if !G.is_valid_node(current_satellite.follow):
		change_state("select_follow")
	else:
		current_satellite.set_follow(null)
		change_state("roam")
		select_satellite(current_satellite)

func _on_release_control():
	select_satellite(null)

func _on_moon_hurtbox_entered(area):
	if area.has_meta("damage"):
		moon_hurt(area.get_meta("damage"))

func moon_hurt(d):
		moon_hp -= d
		moon_hp_progress.set_val(1.0 * moon_hp / moon_full_hp * 100.0)
		if moon_hp <= 0:
			G.emit_signal("gameover")

func _physics_process(delta):
	var run = "state_" + state
	if has_method(run):
		call(run, delta)

	for s in G.satellites:
		
		#try to match the velocity of target
		if G.is_valid_node(s.follow):
			var cur_velocity = s.current_velocity
			var tar_velocity = s.follow.current_velocity
			var a = (tar_velocity - cur_velocity) / 0.1
			s.boost(a, delta)
		else:
			s.update_velocity([G.moon], delta)
			s.boost(Vector2.ZERO, delta)

		s.update_position(delta)
		
	if !G.is_valid_node(current_satellite):
		current_satellite = null

	if current_satellite:
		predict_orbit(current_satellite.position, current_satellite.current_velocity)

func predict_orbit(p, v):
	prediction.clear_points()
	for i in range(200):
		prediction.add_point(p)
		var a = CelestiaBody.GRAVITATIONAL_CONSTANT * G.moon.mass / p.length_squared() * (-p).normalized()
		v += a * 0.1
		p += v * 0.1
		if p.length() < moon_radius:
			break
			
func change_to_follow_cam(s):
	follow_cam.target = s
	follow_cam.current = true
	G.emit_signal("change_camera", follow_cam)

func change_to_roam_cam():
	roam_cam.current = true
	roam_cam.target_position = follow_cam.position
	G.emit_signal("change_camera", roam_cam)

func select_satellite(s):
	if current_satellite:
		current_satellite.set_select(false)
	current_satellite = s
	if s:
		current_satellite.set_select(true)
		change_to_follow_cam(s)
	else:
		change_to_roam_cam()

	G.emit_signal("satellite_selected", s)
	prediction.visible = (s != null and !G.is_valid_node(s.follow))

func _on_satellite_dead(s):
	if current_satellite == s:
		select_satellite(null)
