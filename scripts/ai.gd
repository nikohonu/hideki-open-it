extends Node
class_name AI

func negamax(state, depth, alpha, beta, color):
	if depth == 0 or state.check_end():
		return {"value": state.eval() * color, "cursor": state.cursor}
	var value = -INF
	var best_child = null
	for child in state.children():
		var eval = -(negamax(child, depth - 1, -beta, -alpha, -color).value)
		if value < eval:
			value = max(value, eval)
			alpha = max(alpha, value)
			best_child = child
			if alpha >= beta:
				break
	return {"value": value, "cursor": best_child.cursor}


func calc(state, level):
	var depth = round(min(max((state.step / 64. * level), 1), level))
	#print(depth, " ", state.step, " ", level)
	var color = -2 * state.turn + 1
	return negamax(state, depth, -INF, INF, color).cursor
