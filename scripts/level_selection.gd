extends Control


@onready var level_buttons = [
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/Level 1",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/Level 2",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/Level 3",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer/Level 4",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer2/Level 5",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/VBoxContainer2/Level 6",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/Level 7",
	$"MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/Level 8",
]


func _ready():
	for i in range(8):
		level_buttons[i].status = Global.progress[i]


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _load_level(level: int):
	Global.load_game()
	if Global.level.progress != level:
		Global.level = load("res://levels/level%s.tres" % level)
		Global.state = null
		print("Overwrite level")
	else:
		print("Load level")
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_level_1_pressed():
	_load_level(1)


func _on_level_2_pressed():
	_load_level(2)


func _on_level_3_pressed():
	_load_level(3)


func _on_level_4_pressed():
	_load_level(4)


func _on_level_5_pressed():
	_load_level(5)


func _on_level_6_pressed():
	_load_level(6)


func _on_level_7_pressed():
	_load_level(7)


func _on_level_8_pressed():
	_load_level(8)
