extends Control


var overwrite_level: int

@export var level_button_container: GridContainer

@onready var level_buttons = level_button_container.get_children()


func _ready():
	if Global.saved_level != -1:
		level_buttons[Global.saved_level].has_save = true
	for i in range(Global.LEVEL_COUNT):
		level_buttons[i].icon = _level_to_kanji(i)
		if i < Global.progress:
			level_buttons[i].status = LevelButton.Status.COMPLETED
		elif i == Global.progress :
			level_buttons[i].status = LevelButton.Status.ACTIVE
		else:
			level_buttons[i].status = LevelButton.Status.LOCKED
		level_buttons[i].text = tr(Global.levels[i].name)
		level_buttons[i].pressed.connect(_start_level.bind(i))


func _level_to_kanji(level: int):
	if level < 12:
		@warning_ignore("integer_division")
		var value = level / 3
		match value:
			0: return "春"
			1: return "夏"
			2: return "秋"
			3: return "冬"
	match level:
		12: return "刀"
		13: return "昏"
		14: return "侍"
		15: return "将"
		16: return "桜"
		17: return "死"


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


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_ok_pressed():
	print("Overwrite level")
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_cancel_pressed():
	$PanelContainer.visible = false
