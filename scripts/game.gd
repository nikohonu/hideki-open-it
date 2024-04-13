class_name Game
extends Node3D

@export var level: Level

var ai = []
var Cell = preload("res://scenes/cell.tscn")

@onready var map: Map = %Map
@onready var ui: UI = $UI
@onready var cursor = $Map/Cursor
@onready var state = State.new()
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	if Global.level != null:
		level = Global.level
	ai = [level.player1, level.player2]
	state.game_ended.connect(_on_state_game_ended)
	ui.set_level(level.name)
	ui.set_turn(state.turn)
	ui.set_scores(state.scores)
	audio_stream_player.set_stream(level.music)
	audio_stream_player.play()
	for y in range(8):
		for x in range(8):
			map.add_cell(Cell, Vector2i(x, y), state.map[y][x])


func _process(_delta):
	pass


func _on_cursor_selected(coords):
	if state.is_possible_move(coords):
		map.select(coords)
		
		state.select(coords)
		
		ui.set_turn(state.turn)
		ui.set_scores(state.scores)


func _on_state_game_ended(winner):
	print(winner)
