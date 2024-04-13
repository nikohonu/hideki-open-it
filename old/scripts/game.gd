extends Node3D
class_name Game

enum Player { FIRST, SECOND }

@export_enum("Human:0", "AI 1:1", "AI 2:2", "AI 3:4", "AI 4:8", "AI 5:16") var player1: int = 0
@export_enum("Human:0", "AI 1:1", "AI 2:2", "AI 3:4", "AI 4:8", "AI 5:16") var player2: int = 0

@onready var panel: PanelUI = %PanelUI
@onready var map = %Map
@onready var cursor = %Cursor

var ai: Array
var level: int
var scores: Array
var turn: Player
var step: int


func _ready():
	player1 = Global.get_param("player1", player1)
	player2 = Global.get_param("player2", player1)
	level = Global.get_param("level", 0)
	scores = Global.get_param("scores", [0, 0])
	step = Global.get_param("step", 0)
	turn = Global.get_param("turn", Player.FIRST)
	panel.add_score(Player.FIRST, scores[Player.FIRST])
	panel.add_score(Player.SECOND, scores[Player.SECOND])
	if level != 0:
		%LabelLevel.text = "Level %s" % level
	else:
		%LabelLevel.text = "Undefined Fantastic Object"
	ai = [player1, player2]


func add_score(player: Player, score: int):
	scores[player] += score
	panel.add_score(player, score)


func next_turn():
	turn = Player.SECOND if turn == Player.FIRST else Player.FIRST
	panel.set_turn(turn)
	step += 1
	return turn
