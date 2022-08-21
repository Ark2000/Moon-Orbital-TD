extends Area2D

var areas = {}

func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(a):
	areas[a] = 0

func _on_area_exited(a):
	areas.erase(a)
