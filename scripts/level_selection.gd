extends Control

var overwrite_level: int

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
@onready var levels: Dictionary = {
	"Igarashi Kenji (Easy)": "res://levels/level1.tres",
	"Uemura Akira (Easy)": "res://levels/level2.tres",
	"Shima Ko (Medium)": "res://levels/level3.tres",
	"Chino Kumiko (Medium)": "res://levels/level4.tres",
	"Oba Shiro (Hard)": "res://levels/level5.tres",
	"Sasaki Harukod (Hard)": "res://levels/level6.tres",
	"Okano Momo (Expert)": "res://levels/level7.tres",
	"Mukai Hideki (Expert)": "res://levels/level8.tres",
}


func _ready():
	if Global.state != null:
		level_buttons[Global.level.progress - 1].has_save = true
	for i in range(8):
		level_buttons[i].status = Global.progress[i]
		level_buttons[i].text = levels.keys()[i]


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _load_level(level: int):
	if Global.state == null or Global.level.progress != level:
		overwrite_level = level
		$PanelContainer.visible = true
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


func _on_ok_pressed():
	Global.level = load(levels.values()[overwrite_level - 1])
	Global.state = null
	print("Overwrite level")
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_cancel_pressed():
	$PanelContainer.visible = false
