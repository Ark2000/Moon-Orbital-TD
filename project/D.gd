class_name D

const moon_hp = 1000

const satellite_fall_damage = 60

const turret_base_bullet_speed = 1400

const turret_base_damage = 30

const turret_base_fire_rate = 0.5

const enemy_base_speed = 400.0

const enemy_base_damage = 40

const enemy_base_hp = 40

const buff_data = {
	"B20": {
		"cool_down": 20,
		"cool_down_inc": 10,
		"desc": "the ability to shoot",
		"max_value": 6,
		"threshold_value": 3,
		"add_buf_method": "_add_buff_b20",
		"remove_buf_method": "_remove_buff_b20",
		"icon_path": "res://turret.png",
		"radius": 400,
		
	},
	"IncreaseExplodeRadius": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase explosion range",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_explode_radius",
		"remove_buf_method": "_remove_buff_inc_explode_radius",
		"icon_path": "res://shatter.png",
		"radius": 600,
	},
	"IncreaseHomingAbility": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase homing ability",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_homing_ability",
		"remove_buf_method": "_remove_buff_inc_homing_ability",
		"icon_path": "res://missile-launcher.png",
		"radius": 600,
	},
	"IncreaseBarrelAmount": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase amount of barrels",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_barrel_amount",
		"remove_buf_method": "_remove_buff_inc_barrel_amount",
		"icon_path": "res://double-shot.png",
		"radius": 600,
	},
	"IncreaseBulletSpeed": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase bullet speed",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_bullet_speed",
		"remove_buf_method": "_remove_buff_inc_bullet_speed",
		"icon_path": "res://supersonic-bullet.png",
		"radius": 600,
	},
	"IncreaseFireRate": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase fire rate",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_fire_rate",
		"remove_buf_method": "_remove_buff_inc_fire_rate",
		"icon_path": "res://minigun.png",
		"radius": 600,
	},
	"IncreaseDamage": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase damage",
		"max_value": 6,
		"threshold_value": 4,
		"add_buf_method": "_add_buff_inc_damage",
		"remove_buf_method": "_remove_buff_inc_damage",
		"icon_path": "res://silver-bullet.png",
		"radius": 600,
	},
	"IncreaseRepairing": {
		"cool_down": 15,
		"cool_down_inc": 10,
		"desc": "increase repairing",
		"max_value": 20,
		"threshold_value": 15,
		"add_buf_method": "_add_buff_inc_repairing",
		"remove_buf_method": "_remove_buff_inc_repairing",
		"icon_path": "res://healing-shield.png",
		"radius": 600,
	}
}

#prepare_time, [start_time, end_time, amount] * 3, size, hp, speed, damage
const rules = [
	[1, 0, 30, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[30, 0, 30, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[30, 0, 30, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 6, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 8, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 10, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 12, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 3, 0, 0, 0, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 4, 0, 0, 0, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 5, 0, 0, 0, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 0, 0, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 3, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 4, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 5, 1, 1, 1, 1],
	[10, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 1, 1, 1, 1],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 1.2, 1.5, 1.2, 1.2],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 1.4, 2, 1.4, 1.4],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 1.6, 2.5, 1.6, 1.6],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 1.8, 3, 1.8, 1.8],
	[20, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 2.0, 3.5, 1.0, 2.0],
	[60, 0, 30, 12, 10, 30, 12, 0, 20, 12, 0, 30, 12, 3.0, 4, 3.0, 3.0],
]
