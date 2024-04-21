extends Control

var overwrite_level: int

@onready var level_buttons = $MarginContainer/VBoxContainer/GridContainer.get_children()


func _ready():
	if Global.saved_state != null:
		level_buttons[Global.saved_level].has_save = true
	var level_count = len(Global.levels)
	for i in range(level_count):
		level_buttons[i].icon_text = _level_to_kanji(i)
		if i < Global.progress:
			level_buttons[i].status = LevelButton.Status.COMPLETED
		elif i == Global.progress :
			level_buttons[i].status = LevelButton.Status.ACTIVE
		else:
			level_buttons[i].status = LevelButton.Status.LOCKED
		level_buttons[i].text = Global.levels[i].name
		level_buttons[i].pressed.connect(_start_level.bind(i))


func _level_to_kanji(level: int):
	if level < 12:
		@warning_ignore("integer_division")
		var j = level / 3
		if j == 0:
			return "春"
		if j == 1:
			return "夏"
		if j == 2:
			return "秋"
		if j == 3:
			return "冬"
	if level == 12:
		return "刀"
	if level == 13:
		return "昏"
	if level == 14:
		return "侍"
	if level == 15:
		return "将"
	if level == 16:
		return "桜"
	if level == 17:
		return "死"


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _start_level(level: int):
	Global.current_level = level
	if Global.saved_state == null:
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")
		return
	if Global.saved_level == level and Global.saved_level != null:
		Global.should_load_saved_state = true
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	else:
		$PanelContainer.visible = true


func _on_ok_pressed():
	print("Overwrite level")
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_cancel_pressed():
	$PanelContainer.visible = false
