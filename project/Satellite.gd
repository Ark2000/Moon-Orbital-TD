extends CelestiaBody

signal selected()

onready var hurtbox = $HurtBox
onready var progress = $CircleProgress
onready var flame = $Flame
onready var arrow = $Arrow
onready var turret = $Turret

const accel = 10000.0

var full_hp = 100.0
var hp

var selected = false

func set_select(b):
	selected = b
	arrow.visible = b
	flame.visible = b
	turret.selected = b

func _ready():
	hurtbox.connect("area_entered", self, "_on_area_entered")
	hurtbox.set_meta("owner", self)
	hp = full_hp

func _physics_process(delta):
	var mpos = get_local_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		if mpos.length_squared() < 2500:
			emit_signal("selected")

	if selected:
		arrow.rotation = mpos.angle()
		if Input.is_action_pressed("e"):
			var a = mpos.normalized() * accel * delta
			current_velocity += a * delta
			flame.visible = true
			flame.rotation = a.rotated(PI).angle()
		else:
			flame.visible = false

func _on_area_entered(area):
	if area.has_meta("damage"):
		hp -= area.get_meta("damage")
		progress.set_val(hp / full_hp * 100.0)
		if hp <= 0:
			queue_free()
			G.satellites.erase(self)
			G.spawn_explosion_se(global_position)
