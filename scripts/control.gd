extends MarginContainer


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
