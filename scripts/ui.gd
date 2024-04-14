class_name UI
extends Control


@export var game: Game


func set_level(name):
	$VBoxContainer/Level.set_text(name)


func set_turn(turn):
	$VBoxContainer/Turn.set_text("Turn: Player %s" % (turn + 1))


func set_scores(scores: Array):
	$VBoxContainer/Player1Score.set_text("Player 1 Score: %s" % scores[0])
	$VBoxContainer/Player2Score.set_text("Player 2 Score: %s" % scores[1])


func _on_back_pressed():
	Global.save_game(game.level, game.state)
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")
