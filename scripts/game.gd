class_name Game
extends Node3D

var CellScene = preload("res://scenes/cell.tscn")
var ai = []
var state: State = null

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var cursor = $Map/Cursor
@onready var level: Level = Global.level
@onready var map: Map = %Map
@onready var ui: UI = $UI
@onready var arrows: Array[AnimatedSprite2D] = [$Arrow1, $Arrow2]


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
			map.add_cell(CellScene, Vector2i(x, y), state.map[y][x])
	color()


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
	Global.save_progress()
	Global.reset_save()


func color():
	var center = Vector2i(get_viewport().size / 2)
	var cell_size = 96
	for i in range(8):
		for j in range(8):
			map.cells[Vector2i(i, j)].set_active(false)
	if state.turn == state.PLAYER1:
		arrows[0].position.x = center.x - 4 * cell_size - cell_size / 2
		arrows[1].position.x = center.x + 4 * cell_size + cell_size / 2
		arrows[0].position.y = center.y - (cell_size * 4) + cell_size * state.cursor.y + cell_size / 2
		arrows[1].position.y = center.y - (cell_size * 4) + cell_size * state.cursor.y + cell_size / 2
		arrows[0].rotation = 0
		arrows[1].rotation = PI
		for i in range(8):
			map.cells[Vector2i(i, state.cursor.y)].set_active(true)
	if state.turn == state.PLAYER2:
		arrows[0].position.y = center.y - 4 * cell_size - cell_size / 2
		arrows[1].position.y = center.y + 4 * cell_size + cell_size / 2
		arrows[0].position.x = center.x - (cell_size * 4) + cell_size * state.cursor.x + cell_size / 2
		arrows[1].position.x = center.x - (cell_size * 4) + cell_size * state.cursor.x + cell_size / 2
		arrows[0].rotation = PI / 2
		arrows[1].rotation = PI / 2 * 3
		for i in range(8):
			map.cells[Vector2i(state.cursor.x, i)].set_active(true)


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
	else:
		$UI/PanelContainer/MarginContainer/Custom/Label.set_text("Players %s win!" % (winner + 1))
		$UI/PanelContainer/MarginContainer/Custom.visible = true


func _on_restart_level_pressed():
	Global.state = null
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_next_level_pressed():
	Global.state = null
	if level.progress < 8:
		Global.level = load("res://levels/level%s.tres" % (level.progress + 1))
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_choose_level_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")


func _on_change_settings_pressed():
	Global.level = Global.prev_level
	Global.state = Global.prev_state
	get_tree().change_scene_to_file("res://scenes/custom.tscn")


func _on_audio_stream_player_finished():
	audio_stream_player.play()
