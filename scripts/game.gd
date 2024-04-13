extends Node3D
class_name Game

enum Difficulty {HUMAN = 0, EASY = 1, MEDIUM = 4, HARD = 8,	EXPERT = 16}

signal turn_changed

@export var Player1AI: Difficulty 
@export var Player2AI: Difficulty 

@onready var map: Map = %Map
@onready var ui: UI = $UI
@onready var cursor = $Map/Cursor

var cell_scene = preload("res://scenes/cell.tscn")

@onready var state = State.new()
var ai = []



func _ready():
	ai = [Player1AI, Player2AI]
	state.game_ended.connect(_on_state_game_ended)
	ui.set_turn(state.turn)
	ui.set_scores(state.scores)
	for y in range(8):
		for x in range(8):
			map.add_cell(cell_scene, Vector2i(x, y), state.map[y][x])


func _process(_delta):
	pass


func _on_cursor_selected(coords):
	if state.is_possible_move(coords):
		map.select(coords)
		
		state.select(coords)
		
		ui.set_turn(state.turn)
		ui.set_scores(state.scores)
		
		turn_changed.emit()

func _on_state_game_ended(winner):
	print(winner)
