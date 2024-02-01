extends Node3D
class_name Game

enum Player { FIRST, SECOND }

@export_enum("1:0", "2:1", "3:2", "4:3", "5:4", "6:5", "7:6", "8:7") var level: int = 0
@export_enum("Human:0", "Easy:1", "Medium:1", "Hard:1") var player1: int = 0
@export_enum("Human:0", "Easy:1", "Medium:1", "Hard:1") var player2: int = 0

@onready var panel: PanelUI = %PanelUI
@onready var ai = [player1, player2] 

var scores = [0, 0]
var turn = Player.FIRST

func add_score(player: Player, score: int):
	scores[player] += score
	panel.add_score(player, score)

func next_turn():
	turn = Player.SECOND if turn == Player.FIRST else Player.FIRST
	panel.set_turn(turn)
	return turn
