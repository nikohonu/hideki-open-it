extends Node3D
class_name Game

@onready var panel: PanelUI = %PanelUI

enum Player { FIRST, SECOND }

var scores = [0, 0]
var turn = Player.FIRST

func add_score(player: Player, score: int):
	scores[player] += score
	panel.add_score(player, score)

func next_turn():
	turn = Player.SECOND if turn == Player.FIRST else Player.SECOND
	panel.set_turn(turn)
	return turn
