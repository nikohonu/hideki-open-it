class_name UI
extends Control

@export var game: Game
@export var panel: PanelContainer
@export var level_number_label: Label
@export var level_name_label: Label
@export var turn_label: Label
@export var player_top_label: Label
@export var player_bottom_label: Label
@export var win_message: VBoxContainer
@export var lose_message: VBoxContainer
@export var custom_message: VBoxContainer
@export var custom_result_label: Label
@export var next_level_button: Button
@export var player1_indicator: Label3D
@export var player2_indicator: Label3D

var history = []


func _ready() -> void:
	await game.ready
	if Global.current_level >= 0:
		level_number_label.set_text(tr("LEVEL") + " %s" % (Global.current_level + 1))
		level_name_label.set_text(game.level.name)
	else:
		level_number_label.set_text("")
		level_name_label.set_text(tr("СUSTOMIZED_GAME"))
	player1_indicator.set_text(_get_player_text(0, game.level.ai[0]))
	player2_indicator.set_text(_get_player_text(1, game.level.ai[1]))
	_set_turn(game.state.turn)
	_set_scores(game.state.scores)

func _get_player_text(turn, ai):
	if ai == 0:
		return (tr("PLAYER") + " %s -  " + tr("HUMAN")) % (turn + 1)
	else:
		return (tr("PLAYER") + " %s -  " + tr("AI") + " %s") % [turn + 1, ai]


func _set_turn(turn):
	if turn == 0:
		player1_indicator.modulate.a = 1
		player2_indicator.modulate.a = 0.125
	else:
		player1_indicator.modulate.a = 0.125
		player2_indicator.modulate.a = 1


func _set_scores(scores: Array):
	if scores[0] >= scores[1]:
		player_top_label.set_text((tr("PLAYER") + " 1: %s") % scores[0])
		player_bottom_label.set_text((tr("PLAYER") + " 2: %s") % scores[1])
	else:
		player_top_label.set_text((tr("PLAYER") + " 2: %s") % scores[1])
		player_bottom_label.set_text((tr("PLAYER") + " 1: %s") % scores[0])


func _on_back_pressed():
	game.back()


func _on_restart_pressed() -> void:
	game.restart()


func _on_game_state_changed(new_state: State) -> void:
	#_set_turn(new_state.turn)
	_set_scores(new_state.scores)


func _on_next_level_pressed() -> void:
	game.next_level()


func _on_map_opened(winner: int, is_player_win: bool) -> void:
	panel.visible = true
	if Global.current_level == len(Global.levels) - 1:
		get_tree().change_scene_to_file("res://scenes/credits.tscn")
		#next_level_button.visible = false
	if Global.current_level == -1:
		custom_result_label.set_text(tr("PLAYER_%s_WIN" % (winner + 1)))
		custom_message.visible = true
		return
	if is_player_win:
		win_message.visible = true
	else:
		lose_message.visible = true


func _on_map_cell_animation_finished() -> void:
	_set_turn(game.state.turn)
