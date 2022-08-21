extends CanvasLayer

const bar_prefab = preload("res://AbilityBar.tscn")

onready var bars_container = $SatelliteInfo/VBoxContainer/HBoxContainer/AbilityBars
onready var satellite_panel = $SatelliteInfo
onready var release_control_btn = $SatelliteInfo/VBoxContainer/Button2
onready var select_follow_btn = $SatelliteInfo/VBoxContainer/Button
onready var unselect_follow_btn = $SatelliteInfo/VBoxContainer/Button
onready var hint1 = $Hint1
onready var hint2 = $Hint2
onready var hint3 = $Hint3
onready var hint3_label = $Hint3/Label
onready var wave_label = $Label
onready var skills = $Skills
onready var pause_button = $Button
onready var mask = $Pause
onready var gameover_ui = $GameOver
onready var tween = $Tween
onready var tween2 = $Tween2

onready var progress_bg = $Skills/Progress
onready var progress_val = $Skills/Progress/ColorRect

onready var launch_btn2 = $Skills/VBoxContainer/Button2
onready var launch_btn3 = $Skills/VBoxContainer/Button3
onready var launch_btn4 = $Skills/VBoxContainer/Button4
onready var launch_btn5 = $Skills/VBoxContainer/Button5
onready var launch_btn6 = $Skills/VBoxContainer/Button6
onready var launch_btn7 = $Skills/VBoxContainer/Button7
onready var launch_btn8 = $Skills/VBoxContainer/Button8
onready var launch_btn9 = $Skills/VBoxContainer/Button9

onready var resume_btn = $Pause/VBoxContainer/Button12
onready var restart_btn = $GameOver/VBoxContainer/Button9

onready var help_btn_prev = $Pause/VBoxContainer/HBoxContainer/Prev
onready var help_btn_next = $Pause/VBoxContainer/HBoxContainer/Next
onready var help_textrect = $Pause/VBoxContainer/HBoxContainer/TextureRect
onready var help_page_label = $Pause/VBoxContainer/Label3
onready var quit_btn1 = $GameOver/VBoxContainer/Button10
onready var quit_btn2 = $Pause/VBoxContainer/Button11

var cooldowns = {}

var cur_help = 1
const help_pics = [
	preload("res://1a.png"),
	preload("res://9a.png"),
	preload("res://2a.png"),
	preload("res://3a.png"),
	preload("res://4a.png"),
	preload("res://5a.png"),
	preload("res://6a.png"),
	preload("res://7a.png"),
	preload("res://8a.png"),
]

func _ready():
	G.connect("ability_changed", self, "_on_ability_changed")
	G.connect("satellite_selected", self, "_on_satellite_selected")
	G.connect("select_follow_state_changed", self, "_on_select_follow_state_changed")
	G.connect("launch_state_changed", self, "_on_launch_state_changed")
	G.connect("new_wave", self, "_on_new_wave")
	G.connect("satellite_launched", self, "_on_satellite_launched")
	G.connect("gameover", self, "_on_gameover")
	
	launch_btn2.connect("pressed", self, "_on_launch_btn2_pressed")
	launch_btn3.connect("pressed", self, "_on_launch_btn3_pressed")
	launch_btn4.connect("pressed", self, "_on_launch_btn4_pressed")
	launch_btn5.connect("pressed", self, "_on_launch_btn5_pressed")
	launch_btn6.connect("pressed", self, "_on_launch_btn6_pressed")
	launch_btn7.connect("pressed", self, "_on_launch_btn7_pressed")
	launch_btn8.connect("pressed", self, "_on_launch_btn8_pressed")
	launch_btn9.connect("pressed", self, "_on_launch_btn9_pressed")
	
	launch_btn2.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn2])
	launch_btn3.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn3])
	launch_btn4.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn4])
	launch_btn5.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn5])
	launch_btn6.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn6])
	launch_btn7.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn7])
	launch_btn8.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn8])
	launch_btn9.connect("mouse_entered", self, "_on_launch_btn_mouse_entered", [launch_btn9])
	
	launch_btn2.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn2])
	launch_btn3.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn3])
	launch_btn4.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn4])
	launch_btn5.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn5])
	launch_btn6.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn6])
	launch_btn7.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn7])
	launch_btn8.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn8])
	launch_btn9.connect("mouse_exited", self, "_on_launch_btn_mouse_exited", [launch_btn9])
	
	pause_button.connect("pressed", self, "_on_pause_button_pressed")
	resume_btn.connect("pressed", self, "_on_pause_button_pressed")
	restart_btn.connect("pressed", self, "_on_restart_btn_pressed")
	release_control_btn.connect("pressed", self, "_on_release_control_btn_pressed")
	select_follow_btn.connect("pressed", self, "_on_select_follow_btn_pressed")
	help_btn_prev.connect("pressed", self, "_on_help_btn_prev_pressed")
	help_btn_next.connect("pressed", self, "_on_help_btn_next_pressed")
	
	quit_btn1.connect("pressed", self, "_on_quit_btn_pressed")
	quit_btn2.connect("pressed", self, "_on_quit_btn_pressed")

	for b in D.buff_data:
		cooldowns[b] = D.buff_data[b]["cool_down"]
		
	update_launch_btns()
	
	update_help()

func _on_quit_btn_pressed():
	get_tree().change_scene_to(load("res://Home.tscn"))

func _on_help_btn_prev_pressed():
	cur_help = max(1, cur_help - 1)
	update_help()

func _on_help_btn_next_pressed():
	cur_help = min(9, cur_help + 1)
	update_help()
	
func update_help():
	help_textrect.texture = help_pics[cur_help-1]
	help_page_label.text = "%d/9"%cur_help

func _input(_e):
	if !satellite_panel.visible:
		return

	if Input.is_action_just_pressed("r"):
		_on_release_control_btn_pressed()
	if Input.is_action_just_pressed("f"):
		_on_select_follow_btn_pressed()

func update_launch_btns():
	launch_btn2.text = cooldowns["B20"] as String
	launch_btn3.text = cooldowns["IncreaseExplodeRadius"] as String
	launch_btn4.text = cooldowns["IncreaseHomingAbility"] as String
	launch_btn5.text = cooldowns["IncreaseBarrelAmount"] as String
	launch_btn6.text = cooldowns["IncreaseBulletSpeed"] as String
	launch_btn7.text = cooldowns["IncreaseFireRate"] as String
	launch_btn8.text = cooldowns["IncreaseDamage"] as String
	launch_btn9.text = cooldowns["IncreaseRepairing"] as String

func _on_launch_btn_mouse_entered(b):
	if b.get_child_count() > 0:
		b.get_child(0).show()

func _on_launch_btn_mouse_exited(b):
	if b.get_child_count() > 0:
		b.get_child(0).hide()

func _on_restart_btn_pressed():
	get_tree().reload_current_scene()

func _on_satellite_launched(type):
	progress_bg.show()
	tween2.remove_all()
	tween2.interpolate_property(progress_val, "anchor_top", 1.0, 0.0, cooldowns[type])
	tween2.interpolate_callback(progress_bg, cooldowns[type], "hide")
	tween2.start()
	
	cooldowns[type] += D.buff_data[type]["cool_down_inc"]
	update_launch_btns()

func _on_new_wave(n, t, _c):
	wave_label.text = "WAVE %d" % n
	hint3.show()
	tween.remove_all()
	for i in range(t):
		var new_text =  "WAVE %d STARTS IN %d" % [n, t - i]
		tween.interpolate_callback(hint3_label, i, "set_text", new_text)
	tween.interpolate_callback(hint3, t, "hide")
	tween.start()

func _on_gameover():
	Engine.time_scale = 0.1
	gameover_ui.show()

func _on_pause_button_pressed():
	if Engine.time_scale == 1:
		Engine.time_scale = 0
		mask.show()
		pause_button.icon = preload("res://play-button.png")
	else:
		Engine.time_scale = 1
		mask.hide()
		pause_button.icon = preload("res://pause-button.png")

func _on_launch_btn2_pressed():
	G.emit_signal("launch_btn_pressed", "B20")
func _on_launch_btn3_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseExplodeRadius")
func _on_launch_btn4_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseHomingAbility")
func _on_launch_btn5_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseBarrelAmount")
func _on_launch_btn6_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseBulletSpeed")
func _on_launch_btn7_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseFireRate")
func _on_launch_btn8_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseDamage")
func _on_launch_btn9_pressed():
	G.emit_signal("launch_btn_pressed", "IncreaseRepairing")

func _on_launch_state_changed(state):
	hint2.visible = state
	skills.visible = !state

func _on_select_follow_state_changed(state):
	hint1.visible = state

func _on_select_follow_btn_pressed():
	G.emit_signal("select_follow_btn_pressed")

func _on_release_control_btn_pressed():
	G.emit_signal("release_control")

func _on_ability_changed(buffs):
	set_bars(buffs)
	
func _on_satellite_selected(selected):
	satellite_panel.visible = (selected != null)
	if selected:
		select_follow_btn.text = "UNFOLLOW(F)" if G.is_valid_node(selected.follow) else "FOLLOW(F)"
func set_bars(buffs):
	var diff = buffs.size() - bars_container.get_child_count()
	if diff > 0:
		for i in range(diff):
			bars_container.add_child(bar_prefab.instance())
	for i in range(buffs.size()):
		var bar = bars_container.get_child(i)
		bar.show()
		bar.set_icon(buffs[i].icon)
		bar.set_progress(buffs[i].current_value / buffs[i].max_value)
		bar.set_threshold(buffs[i].threshold_value / buffs[i].max_value)
		bar.set_desc(D.buff_data[buffs[i].buff_name]["desc"])
	if diff < 0:
		for i in range(-diff):
			var bar = bars_container.get_child(buffs.size() + i)
			bar.hide()
