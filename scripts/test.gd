extends Control


@export var game: Game


func _input(event):
	if event.is_action_pressed("test"):
		visible = !visible
	if game:
		if event.is_action_pressed("win"):
			if Global.current_level % 2 == 0:
				game.state.game_ended.emit(1)
			else:
				game.state.game_ended.emit(0)
		if event.is_action_pressed("lose"):
			if Global.current_level % 2 == 0:
				game.state.game_ended.emit(0)
			else:
				game.state.game_ended.emit(1)


func _on_reset_progress_pressed():
	Global.progress = 0
	Global.save_progress()


func _on_reset_state_pressed():
	Global.reset_save()

