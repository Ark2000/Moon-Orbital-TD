extends Node

signal ability_changed(buffs)
signal satellite_selected(selected)
signal release_control()
signal select_follow_btn_pressed()
signal select_follow_state_changed(state)
signal launch_state_changed(state)
signal launch_btn_pressed(type)
signal satellite_fall()
signal change_camera(cam)
signal new_wave(n, t, count)
signal enemy_dead()
signal satellite_launched(type)
signal gameover()

const explosion_prefab = preload("res://Explosion.tscn")
const explosion02_prefab = preload("res://Explosion02.tscn")
const dotted_line_prefab = preload("res://DottedLine.tscn")

var moon = null
var satellites = {}
var enemies = {}
var marks = {}

func add_mark(enemy):
	if !marks.has(enemy):
		marks[enemy] = 0
	marks[enemy] += 1

func remove_mark(enemy):
	if marks.has(enemy):
		marks[enemy] -= 1
		if marks[enemy] == 0:
			marks.erase(enemy)

func spawn_dottedLine(a, b):
	var e = dotted_line_prefab.instance()
	e.a = a
	e.b = b
	get_tree().current_scene.call_deferred("add_child", e)

func spawn_explosion_se(pos):
	var e = explosion_prefab.instance()
	e.position = pos
	get_tree().current_scene.call_deferred("add_child", e)

func spawn_explosion02(pos):
	var e = explosion02_prefab.instance()
	e.position = pos
	e.scale = Vector2.ONE * 2
	get_tree().current_scene.call_deferred("add_child", e)
	return e

static func is_valid_node(n):
	return n and is_instance_valid(n) and (n is Node) and !n.is_queued_for_deletion()

static func angle_diff(from, to):
	return fposmod(to-from + PI, PI*2) - PI
