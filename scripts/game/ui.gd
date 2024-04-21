class_name UI
extends Control

@export var game: Game
@export var panel: PanelContainer
@export var level_name_label: Label
@export var turn_label: Label
@export var player1_score_label: Label
@export var player2_score_label: Label
@export var win_message: VBoxContainer
@export var lose_message: VBoxContainer
@export var custom_message: VBoxContainer
@export var custom_result_label: Label
@export var next_level_button: Button


func _ready() -> void:
	await game.ready
	_set_level_name(game.level.name)
	_set_turn(game.state.turn)
	_set_scores(game.state.scores)


func _set_level_name(level_name):
	level_name_label.set_text(level_name)


func _set_turn(turn):
	turn_label.set_text("Turn: Player %s" % (turn + 1))


func _set_scores(scores: Array):
	player1_score_label.set_text("Player 1 Score: %s" % scores[0])
	player2_score_label.set_text("Player 2 Score: %s" % scores[1])


func _on_back_pressed():
	game.back()


func _on_restart_pressed() -> void:
	game.restart()


func _on_game_state_changed(new_state: State) -> void:
	_set_turn(new_state.turn)
	_set_scores(new_state.scores)


func _on_next_level_pressed() -> void:
	game.next_level()


func _on_map_opened(winner: int, is_player_win: bool) -> void:
	panel.visible = true
	if Global.current_level == len(Global.levels) - 1:
		next_level_button.visible = false
	if Global.current_level == -1:
		custom_result_label.set_text("Players %s win!" % (winner + 1))
		custom_message.visible = true
		return
	if is_player_win:
		win_message.visible = true
	else:
		lose_message.visible = true
