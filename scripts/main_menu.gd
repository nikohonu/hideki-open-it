extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection/level_selection.tscn")


func _on_exit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_control_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")


func _on_custom_pressed():
	get_tree().change_scene_to_file("res://scenes/custom.tscn")
