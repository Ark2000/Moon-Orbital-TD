extends Node2D

onready var center_s = $Satellite10
onready var s1 = $Satellite11
onready var s2 = $Satellite12
onready var s3 = $Satellite13
onready var s4 = $Satellite14

func _ready():
	for s in [center_s, s1, s2, s3, s4]:
		G.satellites[s] = 0
		s.connect("dead", get_parent(), "_on_satellite_dead", [s])
	s1.set_follow(center_s)
	s2.set_follow(center_s)
	s3.set_follow(center_s)
	s4.set_follow(center_s)

	s1._set_type("IncreaseFreRate")
	s2._set_type("IncreaseFireRate")
	s3._set_type("IncreaseFireRate")
	s4._set_type("IncreaseFireRate")
