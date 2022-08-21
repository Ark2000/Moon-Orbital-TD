tool
extends Node2D

var celestial_bodies = []

export var update_sim := false

func _ready():
	if Engine.editor_hint:
		while true:
			update_simulation()
			yield(get_tree().create_timer(0.5), "timeout")
	
	for c in get_children():
		if c is CelestiaBody:
			celestial_bodies.append(c)

func _physics_process(delta):
	if Engine.editor_hint: return
	for c in celestial_bodies:
		c.update_velocity(celestial_bodies, delta)
	for c in celestial_bodies:
		c.update_position(delta)

var lines = {}
var colors = {}
func update_simulation():
	if !update_sim: return
		
	var bodies = []
	for c in get_children():
		if c is CelestiaBody:
			bodies.append(c)
			if !colors.has(c):
				colors[c] = Color(randf(), randf(), randf(), 1.0)

	for l in lines:
		lines[l].queue_free()
	lines.clear()

	var all_data = []
	
	for c in bodies:
		var data = CelestiaBody.Data.new()
		data.velocity = c.initial_velocity
		data.mass = c.mass
		data.position = c.position
		all_data.append(data)
		lines[data] = Line2D.new()
		lines[data].default_color = colors[c]
		add_child(lines[data])
	
	#simulate 2 min
	var time_step = 0.0167
	for i in range(60 * 60):
		for d in all_data:
			d.update_velocity(all_data, time_step)
		for d in all_data:
			d.update_position(time_step)
			if i % 10 == 0:
				lines[d].add_point(d.position)
