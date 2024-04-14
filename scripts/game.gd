class_name Game
extends Node3D


var ai = []
var Cell = preload("res://scenes/cell.tscn")
var state = null

@onready var level: Level = Global.level
@onready var map: Map = %Map
@onready var ui: UI = $UI
@onready var cursor = $Map/Cursor
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	if level == null:
		OS.crash("Level was not specified!")
	if Global.state != null:
		state = Global.state
	else:
		state = State.new()
	state.game_ended.connect(_on_state_game_ended)
	ui.set_level(level.name)
	ui.set_turn(state.turn)
	ui.set_scores(state.scores)
	audio_stream_player.set_stream(level.music)
	audio_stream_player.play()
	for y in range(8):
		for x in range(8):
			map.add_cell(Cell, Vector2i(x, y), state.map[y][x])


func _input(event):
	if event.is_action_pressed("win"):
		if level.progress % 2 == 0:
			state.game_ended.emit(1)
		else:
			state.game_ended.emit(0)
	if event.is_action_pressed("lose"):
		if level.progress % 2 == 0:
			state.game_ended.emit(0)
		else:
			state.game_ended.emit(1)


func _on_cursor_selected(coords):
	if state.is_possible_move(coords):
		map.select(coords)
		
		state.select(coords)
		
		ui.set_turn(state.turn)
		ui.set_scores(state.scores)


func mark_complete():
	Global.progress[level.progress - 1] = Global.Status.COMPLETED
	if level.progress < 8 and Global.progress[level.progress] != Global.Status.COMPLETED:
			Global.progress[level.progress] = Global.Status.ACTIVE


func _on_state_game_ended(winner):
	cursor.can_move = false
	$UI/PanelContainer.visible = true
	if level.progress == 8:
		$UI/PanelContainer/MarginContainer/Win/HBoxContainer/NextLevel.visible = false
	if level.progress != 0:
		if level.progress % 2 == 0:
			if winner == 1:
				mark_complete()
				$UI/PanelContainer/MarginContainer/Win.visible = true
			else:
				$UI/PanelContainer/MarginContainer/Lose.visible = true
		else:
			if winner == 0:
				mark_complete()
				$UI/PanelContainer/MarginContainer/Win.visible = true
			else:
				$UI/PanelContainer/MarginContainer/Lose.visible = true


func _on_restart_level_pressed():
	Global.state = null
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_next_level_pressed():
	Global.state = null
	if level.progress < 8:
		Global.level = load("res://levels/level%s.tres" % (level.progress + 1))
		get_tree().change_scene_to_file("res://scenes/game.tscn")
