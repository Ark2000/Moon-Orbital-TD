extends VBoxContainer

onready var icon_texturerect = $HBoxContainer/icon
onready var progress_colorrect = $HBoxContainer/ProgressBar2/Progress
onready var threshold_colorrect = $HBoxContainer/ProgressBar2/P/Threshold
onready var desc_label = $Label

func set_desc(s):
	desc_label.text = s

func set_icon(icon):
	icon_texturerect.texture = icon

func set_progress(v):
	progress_colorrect.anchor_right = v

func set_threshold(v):
	threshold_colorrect.anchor_left = v
	threshold_colorrect.anchor_right = v
