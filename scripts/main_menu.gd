extends Control

@export var continue_button: Button 

func _ready() -> void:
	if Global.saved_level == -1:
		continue_button.visible = false


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection/level_selection.tscn")


func _on_control_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")


func _on_custom_pressed():
	get_tree().change_scene_to_file("res://scenes/custom.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_exit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_continue_pressed() -> void:
	Global.current_level = Global.saved_level
	Global.should_load_saved_state = true
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
