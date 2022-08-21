class_name Satellite10
extends CelestiaBody

signal selected()
signal cancel_follow()
signal dead()

onready var hurtbox = $HurtBox
onready var progress = $CircleProgress
onready var flame = $Flame
onready var arrow = $Arrow
onready var turret = $Turret
onready var buff_detector = $BuffDetector
onready var buff_area = $BuffArea
onready var icon = $Sprite2

var type = "B20"
const accel = 200.0
var full_hp = 100.0
var hp
var repair_rate = 0.0

var selected = false
var follow = null

func set_buff_radius(r):
	yield(self, "ready")
	buff_area.set_radius(r)

func set_type(s):
	type = s

func set_select(b):
	selected = b
	arrow.visible = b
	flame.visible = b
	turret.selected = b
	turret.range_hint.visible = b

func set_follow(f):
	if G.is_valid_node(follow):
		emit_signal("cancel_follow")

	follow = f
	G.spawn_dottedLine(f, self)

func _ready():
	hurtbox.connect("area_entered", self, "_on_area_entered")
	hurtbox.set_meta("owner", self)
	hp = full_hp * 0.5
	
	buff_detector.connect("area_entered", self, "_on_buff_entered")
	buff_detector.connect("area_exited", self, "_on_buff_exited")
	
	icon.texture = load(buff_data[type].icon_path)
	buff_area.set_type(type)

func _physics_process(delta):
	hp = min(hp + repair_rate * delta, full_hp)
	progress.set_val(hp / full_hp * 100.0)

	update_buff(delta)
	var mpos = get_local_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		if mpos.length_squared() < 2500:
			emit_signal("selected")

	if selected:
		arrow.rotation = mpos.angle()
		G.emit_signal("ability_changed", buffs.values())
		if !G.is_valid_node(follow):
			if Input.is_action_pressed("right_click"):
				boost(mpos, delta)
			else:
				boost(Vector2.ZERO, delta)

func boost(v, delta):
	if v == Vector2.ZERO:
		flame.visible = false
	else:
		v = v.clamped(accel)
		current_velocity += v * delta
		flame.visible = true
		flame.rotation = v.rotated(PI).angle()

func _on_area_entered(area):
	if area.has_meta("damage"):
		hp -= area.get_meta("damage")
		if area.get_parent() == G.moon:
			G.emit_signal("satellite_fall")
		if hp <= 0:
			emit_signal("dead")
			queue_free()
			G.satellites.erase(self)
			G.spawn_explosion_se(global_position)

func _on_buff_entered(a):
	if a.has_meta("buff_name"):
		if !buffs.has(a):
			var buff_name = a.get_meta("buff_name")
			buffs[a] = create_buff(buff_name)
		buffs[a].active = true

func _on_buff_exited(a):
	if buffs.has(a):
		buffs[a].active = false

var buffs = {}
const buff_data = D.buff_data

func _remove_buff_b20():
	turret.b20 -= 1
	if turret.b20 == 0:
		turret.visible = false

func _add_buff_b20():
	turret.b20 +=1
	if turret.b20 == 1:
		turret.visible = true

func _add_buff_inc_explode_radius():
	turret.explode_radius += 150

func _remove_buff_inc_explode_radius():
	turret.explode_radius -= 150

func _add_buff_inc_homing_ability():
	turret.homing_ability += 600

func _remove_buff_inc_homing_ability():
	turret.homing_ability -= 600

func _remove_buff_inc_barrel_amount():
	turret.barrels -= 1

func _add_buff_inc_barrel_amount():
	turret.barrels += 1

func _remove_buff_inc_bullet_speed():
	turret.bullet_speed -= 700

func _add_buff_inc_bullet_speed():
	turret.bullet_speed += 700

func _remove_buff_inc_fire_rate():
	turret.set_fire_rate(turret.get_fire_rate() - 0.5)

func _add_buff_inc_fire_rate():
	turret.set_fire_rate(turret.get_fire_rate() + 0.5)

func _remove_buff_inc_damage():
	turret.damage -= 30

func _add_buff_inc_damage():
	turret.damage += 30

func _add_buff_inc_repairing():
	repair_rate += 5.0

func _remove_buff_inc_repairing():
	repair_rate -= 5.0

func create_buff(s):
	var data = buff_data[s]
	var buff = Buff.new()
	buff.max_value = data["max_value"]
	buff.threshold_value = data["threshold_value"]
	buff.current_value = 0
	buff.buff_name = s
	buff.add_buf_method = data["add_buf_method"]
	buff.remove_buf_method = data["remove_buf_method"]
	buff.icon = load(data["icon_path"])
	buff.active = false
	buff.enabled = false
	return buff

func update_buff(delta):
	for k in buffs:
		if buffs[k].active:
			buffs[k].current_value += delta
		else:
			buffs[k].current_value -= delta
		buffs[k].current_value = min(buffs[k].current_value, buffs[k].max_value)
		var status = buffs[k].current_value >= buffs[k].threshold_value
		if status and !buffs[k].enabled:
			call(buffs[k].add_buf_method)
		if !status and buffs[k].enabled:
			call(buffs[k].remove_buf_method)
		buffs[k].enabled = status
		if buffs[k].current_value <= 0:
			buffs.erase(k)

class Buff:
	var active:bool
	var enabled:bool
	var max_value:float
	var threshold_value:float
	var current_value:float
	var icon:Texture
	var buff_name:String
	var add_buf_method:String
	var remove_buf_method:String
