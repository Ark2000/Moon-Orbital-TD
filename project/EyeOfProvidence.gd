extends Camera2D

const smooth_factor = 0.2
export var zoom_min = 0.1
export var zoom_max = 3.0
export var zoom_step = 0.05
export var smooth_dragging = true
export var smooth_zooming = true

var zoom_level = 1
var target_position := Vector2.ZERO
var target_zoom = Vector2(1, 1)

func _ready():
	target_position = position

func _process(_delta):
	position = lerp(position, target_position, smooth_factor)
	zoom = lerp(zoom, target_zoom, smooth_factor)
	
	var size = get_viewport().size * zoom.x
	target_position.x = clamp(target_position.x, -5000 + size.x / 2, 5000 - size.x / 2)
	target_position.y = clamp(target_position.y, -5000 + size.y / 2, 5000 - size.y / 2)

func _unhandled_input(event):
	handle_input(event)

func handle_input(event):
	#Dragging event
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		target_position -= event.relative * zoom.x
		if not smooth_dragging:
			position = target_position
	#Zooming event
	elif event is InputEventMouseButton and event.button_mask != 0:
		var focus_position = get_global_mouse_position()
		var cam_size = get_viewport_rect().size * target_zoom.x
		#zoom = zoom_level * zoom_level
		if event.button_mask == 8:
			zoom_level = max(zoom_min, zoom_level - zoom_step)
			target_zoom = Vector2(1, 1) * pow(zoom_level, 2)
		elif event.button_mask == 16:
			zoom_level = min(zoom_max, zoom_level + zoom_step)
			target_zoom = Vector2(1, 1) * pow(zoom_level, 2)
		var new_cam_size = get_viewport_rect().size * target_zoom.x
		#calculate the appropriate camera position
		target_position.x = focus_position.x - (focus_position.x - target_position.x) * new_cam_size.x / cam_size.x
		target_position.y = focus_position.y - (focus_position.y - target_position.y) * new_cam_size.y / cam_size.y

		if not smooth_zooming:
			position = target_position
			zoom = target_zoom
