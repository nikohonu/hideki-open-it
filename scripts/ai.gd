extends Node

@onready var game: Game = get_tree().get_current_scene()
@onready var map = %Map
@onready var cursor = %Cursor


func negamax(position, depth, alpha, beta, color):
	if depth == 0 or map.check_end(position.player, position.cords, position.map):
		return {"value": position.eval() * color, "cords": position.cords}
	var value = -INF
	var best_child = null
	for child in position.children():
		var eval = -(negamax(child, depth - 1, -beta, -alpha, -color).value)
		if value < eval:
			value = max(value, eval)
			alpha = max(alpha, value)
			best_child = child
			if alpha >= beta:
				break
	return {"value": value, "cords": best_child.cords}


func calc_move(current_map, current_cords, current_player, current_score, level = 1):
	var c = level / 64.
	var depth = max(1, round(game.step * c))
	var color = -2 * current_player + 1
	var position = Position.new(current_map, current_cords, current_player, current_score)
	return negamax(position, depth, -INF, INF, color).cords
