extends Node2D

onready var lsp = $LEnemySpawner
onready var rsp = $REnemySpawner
onready var tsp = $TEnemySpawner
onready var bsp = $BEnemySpawner

onready var tween = $Tween

const rules = D.rules
var current_wave = -1

func next_wave():
	current_wave += 1
	var idx = min(rules.size() - 1, current_wave)
	var r = rules[idx]
	G.emit_signal("new_wave", current_wave, r[0], r[3] + r[6] + r[9] + r[12])
	
	tween.remove_all()
	for i in range(r[3]):
		tween.interpolate_callback(lsp, r[0] + r[1] + (r[2] - r[1]) / r[3] * i, "spawn_an_enemy", r[13], r[14], r[15], r[16])
	for i in range(r[6]):
		tween.interpolate_callback(rsp, r[0] + r[4] + (r[5] - r[4]) / r[6] * i, "spawn_an_enemy", r[13], r[14], r[15], r[16])
	for i in range(r[9]):
		tween.interpolate_callback(tsp, r[0] + r[7] + (r[8] - r[7]) / r[9] * i, "spawn_an_enemy", r[13], r[14], r[15], r[16])
	for i in range(r[12]):
		tween.interpolate_callback(bsp, r[0] + r[10] + (r[11] - r[10]) / r[12] * i, "spawn_an_enemy", r[13], r[14], r[15], r[16])
	tween.start()

	return r[3] + r[6] + r[9] + r[12]
