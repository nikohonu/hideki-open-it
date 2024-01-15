extends Node3D

enum Player { FIRST, SECOND }

var is_player_ai = [false, false]
var player_scores = [0, 0]

var current_player = Player.FIRST:
	set(cp):
		%Panel.update_move_status(cp)
		current_player = cp


func update_score(player, value):
	player_scores[player] += value
	%Panel.update_score(player, player_scores[player])
