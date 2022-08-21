extends TextureProgress

onready var cross = $Cross
onready var progress2 = $TextureProgress

var current_val = 100.0

func set_val(val):
	current_val = val
	if val <= 0:
		cross.show()
	elif val < 30:
		self_modulate = Color.red
	elif val < 60:
		self_modulate = Color.yellow
	else:
		self_modulate = Color.green

func _physics_process(_delta):
	value = lerp(value, current_val, 0.1)
	progress2.value = lerp(progress2.value, current_val, 0.06)
