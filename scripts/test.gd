extends Control


@export var game: Game


func _input(event):
	if event.is_action_pressed("test"):
		visible = !visible
	if game:
		var result = 0 if Global.current_level % 2 == 0 else 1
		if event.is_action_pressed("win"):
			game.state.game_ended.emit(result)
		if event.is_action_pressed("lose"):
			game.state.game_ended.emit(1 - result)


func _on_reset_progress_pressed():
	Global.progress = 0
	Global.save_game()


func _on_reset_state_pressed():
	Global.reset_save()

