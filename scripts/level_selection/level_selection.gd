extends Control


@export var level_button_container: GridContainer
@export var panel_container: PanelContainer

var overwrite_level: int
var prev_selection: int = -1

@onready var level_buttons: Array = level_button_container.get_children()


func _ready():
	if Global.saved_level != -1:
		level_buttons[Global.saved_level].has_save = true
	for i in range(Global.LEVEL_COUNT):
		level_buttons[i].icon = _level_to_kanji(i)
		if i < Global.progress:
			level_buttons[i].status = LevelButton.Status.COMPLETED
		elif i == Global.progress:
			level_buttons[i].status = LevelButton.Status.ACTIVE
		else:
			level_buttons[i].status = LevelButton.Status.LOCKED
		level_buttons[i].text = ("%s. " + tr(Global.levels[i].name)) % (i + 1)
		level_buttons[i].pressed.connect(_start_level.bind(i))
		level_buttons[i].focus_changed.connect(_on_focus_changed)
	_focus()


func _input(event):
	if panel_container.visible == true:
		if event.is_action_pressed("ui_accept"):
			_on_ok_pressed()
		if event.is_action_pressed("ui_cancel"):
			_on_cancel_pressed()
	else:
		if event.is_action_pressed("ui_cancel"):
			_on_back_pressed()


func _focus():
	if Global.is_joypad_connected:
		if prev_selection != -1:
			level_buttons[prev_selection].focus()
		elif Global.saved_level != -1:
			level_buttons[Global.saved_level].focus()
		else:
			if Global.progress == 18:
				level_buttons[Global.progress - 1].focus()
			else:
				level_buttons[Global.progress].focus()

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
		panel_container.visible = true
		for i in range(Global.LEVEL_COUNT):
			level_buttons[i].unfocus()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_ok_pressed():
	print("Overwrite level")
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_cancel_pressed():
	panel_container.visible = false
	_focus()

func _on_focus_changed():
	for i in range(Global.LEVEL_COUNT):
		if level_buttons[i].focused == true:
			prev_selection = i
