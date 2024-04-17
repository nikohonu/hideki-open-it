class_name UI
extends Control

@export var game: Game


func set_level(level_name):
	$VBoxContainer/Level.set_text(level_name)


func set_turn(turn):
	$VBoxContainer/Turn.set_text("Turn: Player %s" % (turn + 1))


func set_scores(scores: Array):
	$VBoxContainer/Player1Score.set_text("Player 1 Score: %s" % scores[0])
	$VBoxContainer/Player2Score.set_text("Player 2 Score: %s" % scores[1])


func _on_back_pressed():
	if game.level.progress != 0:
		Global.save_game(game.level, game.state)
		get_tree().change_scene_to_file("res://scenes/level_selection.tscn")
	else:
		Global.level = Global.prev_level
		Global.state = Global.prev_state
		get_tree().change_scene_to_file("res://scenes/custom.tscn")
