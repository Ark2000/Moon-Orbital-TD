extends Area2D

onready var s1 = $Sprite
onready var s2 = $Sprite2
onready var c = $CollisionShape2D

export var buff_name:String

func _ready():
	set_type(buff_name)

func set_radius(r):
	c.shape.set_deferred("radius", r)
	s1.scale *= r / 400.0
	s2.scale *= r / 400.0

func set_type(s):
	set_meta("buff_name", s)
