extends Node

export var remove_time = 2.0
export var min_segment = 10.0
var _min_segment_sqr
var point_timer = []
var time = 0

func _ready():
	_min_segment_sqr = pow(min_segment, 2)
	if !(get_parent() is Node2D):
		set_physics_process(false)

func _physics_process(delta):
	time += delta

	#the last point should always follow the target
	if $Line2D.get_point_count() > 0:
		$Line2D.set_point_position($Line2D.get_point_count() - 1, get_parent().global_position)
	
	#try to add a point
	add_trail_point()
	
	#remove point
	while $Line2D.get_point_count() > 1:
		if point_timer[0] + remove_time < time:
			$Line2D.remove_point(0)
			point_timer.remove(0)
		else:
			break

func add_trail_point():
	var current_position = get_parent().global_position
	if $Line2D.get_point_count() > 1:
		var last_position = $Line2D.get_point_position($Line2D.get_point_count() - 2)
		if (current_position - last_position).length_squared() < _min_segment_sqr: 
			return
	
	$Line2D.add_point(current_position)
	point_timer.append(time)
