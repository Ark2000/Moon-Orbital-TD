extends ColorRect

const enemy_prefab = preload("res://Enemy1.tscn")
	
func spawn_an_enemy(size_scale := 1.0, hp_scale := 1.0, speed_scale := 1.0, damage_scale := 1.0):
	var pos = rect_global_position
	pos.x += rand_range(0, rect_size.x)
	pos.y += rand_range(0, rect_size.y)
	var enemy = enemy_prefab.instance()
	enemy.position = pos
	enemy.scale = Vector2.ONE * size_scale
	enemy.full_hp *= hp_scale
	enemy.max_linear_velocity *= speed_scale
	enemy.damage *= damage_scale
	get_tree().current_scene.add_child(enemy)
