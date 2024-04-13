extends Control


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _load_level(level: int):
	Global.level = load("res://levels/level%s.tres" % level)
	Global.state = null
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
