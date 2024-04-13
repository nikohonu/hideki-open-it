extends Control


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")


func _on_exit_pressed():
	get_tree().quit()