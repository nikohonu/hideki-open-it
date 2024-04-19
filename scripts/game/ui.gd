class_name UI
extends Control

@export var game: Game


func _ready() -> void:
	await game.ready
	set_level(game.level.name)
	set_turn(game.state.turn)
	set_scores(game.state.scores)


func set_level(level_name):
	$VBoxContainer/Level.set_text(level_name)


func set_turn(turn):
	$VBoxContainer/Turn.set_text("Turn: Player %s" % (turn + 1))


func set_scores(scores: Array):
	$VBoxContainer/Player1Score.set_text("Player 1 Score: %s" % scores[0])
	$VBoxContainer/Player2Score.set_text("Player 2 Score: %s" % scores[1])


func _on_back_pressed():
	if Global.current_level >= 0:
		Global.save_state(game.state)
		Global.saved_level = Global.current_level
		Global.save_game()
		get_tree().change_scene_to_file("res://scenes/level_selection.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/custom.tscn")


func _on_game_state_changed(new_state: State) -> void:
	set_turn(new_state.turn)
	set_scores(new_state.scores)


func _on_restart_pressed() -> void:
	game.restart()


func _on_next_level_pressed() -> void:
	game.next_level()
