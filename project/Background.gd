extends CanvasLayer

onready var bg1 = $TextureRect2
onready var bg2 = $TextureRect3

var current_camera

func _ready():
	G.connect("change_camera", self, "_on_change_camera")
	
func _on_change_camera(cam):
	current_camera = cam
	
func _process(delta):
	if G.is_valid_node(current_camera):
		bg1.rect_position = Vector2(-5000, -5000) + -current_camera.get_camera_screen_center() / 10
		bg2.rect_position = Vector2(-5000, -5000) + -current_camera.get_camera_screen_center() / 4
