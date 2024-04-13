class_name AI
extends Node


func calc(state, level) -> Vector2i:
	var depth = round(min(max((state.step / 64. * level), 1), level))
	var color = -2 * state.turn + 1
	return _negamax(state, depth, -INF, INF, color).cursor


func _negamax(state, depth, alpha, beta, color) -> Dictionary:
	if depth == 0 or state.check_end():
		return {"value": state.eval() * color, "cursor": state.cursor}
	var value = -INF
	var best_child = null
	for child in state.children():
		var eval = -(_negamax(child, depth - 1, -beta, -alpha, -color).value)
		if value < eval:
			value = max(value, eval)
			alpha = max(alpha, value)
			best_child = child
			if alpha >= beta:
				break
	return {"value": value, "cursor": best_child.cursor}
