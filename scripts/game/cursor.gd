class_name Cursor
extends AnimatedSprite3D


signal cell_selected(coords: Vector2i)
signal moved

@export var game: Game
@export var ai: AICPP
@export var map: Map
@export var timer: Timer

var can_move := true
var coords = null


func _ready():
	await game.ready
	await map.ready
	coords = game.state.cursor
	position = Global.coordinates_2d_to_3d(coords, 0.5)
	if game.level.ai[game.state.turn] > 0:
		_ai_move()


func _process(_delta):
	if can_move:
		var move = Vector2i.ZERO
		if game.state.turn == State.PLAYER1 and not game.level.ai[State.PLAYER1]:
			move.x = int(Input.get_action_strength("right") - Input.get_action_strength("left"))
		elif game.state.turn == State.PLAYER2 and not game.level.ai[State.PLAYER2]:
			move.y = int(Input.get_action_strength("down") - Input.get_action_strength("up"))
		if not move:
			return
		var destination = Vector2i(clamp(coords.x + move.x, 0, 7), clamp(coords.y + move.y, 0, 7))
		_move(destination)


func _input(event):
	if can_move:
		if event.is_action_pressed("select"):
			_select_cell()
		if event.is_action_pressed("click"):
			var center = Vector2(get_viewport().size / 2)
			_move(-round((center - event.position) / map.CELL_SIZE - Vector2(3.5, 3.5)), true)


func _move(destination: Vector2i, select_cell: bool = false):
	var move = func():
		timer.start()
		position = Global.coordinates_2d_to_3d(coords, 0.5)
		moved.emit()
		await timer.timeout
	if destination.x > 7 or destination.x < 0 or destination.y > 7 or destination.y < 0:
		return false
	var diff = destination - coords
	can_move = false
	if game.state.turn == State.PLAYER1 and diff.y == 0:
		for _i in range(abs(diff.x)):
			coords.x += diff.x / abs(diff.x)
			await move.call()
	elif game.state.turn == State.PLAYER2 and diff.x == 0:
		for _i in range(abs(diff.y)):
			coords.y += diff.y / abs(diff.y)
			await move.call()
	else:
		can_move = true
		return
	if select_cell:
		_select_cell()
	else:
		can_move = true


func _select_cell():
	if game.state.is_possible_move(coords):
		can_move = false
		visible = false
		cell_selected.emit(coords)
		return
	can_move = true


func _ai_move():
	_move(ai.calc(game.state, game.level.ai[game.state.turn]), true)


func _on_map_cell_animation_finished() -> void:
	visible = true
	if game.level.ai[game.state.turn] > 0 or game.state.possible_move_count() == 1:
		_ai_move()
	else:
		can_move = true


func _on_game_ended(_winner: int, _is_player_win: bool) -> void:
	can_move = false
	visible = false
