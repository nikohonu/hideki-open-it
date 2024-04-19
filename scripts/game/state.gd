class_name State
extends Resource

signal game_ended(winner)
signal state_changed(changed_state)

enum {PLAYER1, PLAYER2}

const MAP_SIZE = 8

var map = []
var turn = PLAYER1
var scores = [0, 0]
var cursor = Vector2i(4, 4)
var step = 0


func _init(prev_state: State = null):
	if prev_state:
		self.map = prev_state.map.duplicate(true)
		self.turn = prev_state.turn
		self.scores = prev_state.scores.duplicate()
		self.cursor = prev_state.cursor
		self.step = prev_state.step
	else:
		var possible_values = _generate_possible_values()
		for i in range(MAP_SIZE):
			var start = i * MAP_SIZE
			map.append(possible_values.slice(start, start + MAP_SIZE))


func possible_move_count():
	var total = 0
	if turn == PLAYER1:
		for x in range(MAP_SIZE):
			total += 1 if map[cursor.y][x] != 0 else 0
	else:
		for y in range(MAP_SIZE):
			total += 1 if map[y][cursor.x] != 0 else 0
	return total


func is_possible_move(coords: Vector2i):
	return map[coords.y][coords.x] != 0


func calc_winner():
	if scores[PLAYER1] == scores[PLAYER2]:
		return -1
	else:
		return PLAYER1 if scores[PLAYER1] > scores[PLAYER2] else PLAYER2


func select(cell_coords: Vector2i):
	cursor = cell_coords
	scores[turn] += map[cursor.y][cursor.x]
	map[cursor.y][cursor.x] = 0
	if turn == PLAYER1:
		turn = PLAYER2
	else:
		turn = PLAYER1
	step += 1
	state_changed.emit(self)
	if possible_move_count() == 0:
		game_ended.emit(calc_winner())


func to_dict():
	return {
		"map": map,
		"turn": turn,
		"scores": scores,
		"cursor_x": cursor.x,
		"cursor_y": cursor.y,
		"step": step,
	}


static func from_dict(dict: Dictionary):
	var state = State.new()
	state.map = dict.map
	state.turn = dict.turn
	state.scores = dict.scores
	state.cursor = Vector2i(dict.cursor_x, dict.cursor_y)
	state.step = dict.step
	return state


func _generate_possible_values() -> Array:
	var possible_values = []
	for value in range(1, 12):
		for _i in range(3):
			possible_values += [value, -value]
	possible_values.shuffle()
	return possible_values.slice(0, MAP_SIZE ** 2)
