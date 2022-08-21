extends Camera2D

var target = null

func _physics_process(delta):
	if G.is_valid_node(target):
		global_position = target.global_position

func _unhandled_input(event):
	#Zooming event
	if event is InputEventMouseButton and event.button_mask != 0:
		var focus_position = get_global_mouse_position()
		if event.button_mask == 8:
			zoom = Vector2.ONE * clamp(zoom.x - 0.1, 0.5, 4.0)
		elif event.button_mask == 16:
			zoom = Vector2.ONE * clamp(zoom.x + 0.1, 0.5, 4.0)
