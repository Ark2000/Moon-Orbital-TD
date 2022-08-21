extends Line2D

var a = null
var b = null

func _ready():
	b.connect("cancel_follow", self, "_on_b_cancel_follow")

func _on_b_cancel_follow():
	queue_free()

func _physics_process(delta):
	if G.is_valid_node(a) and G.is_valid_node(b):
		set_point_position(0, a.global_position)
		set_point_position(1, b.global_position)
	else:
		queue_free()

