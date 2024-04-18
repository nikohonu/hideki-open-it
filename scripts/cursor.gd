class_name Cursor
extends AnimatedSprite3D

signal selected(Vector2i)

enum { PLAYER1, PLAYER2 }

@export var game: Game

var avg = 0
var can_move = true
var coords = null

@onready var ai = $AICPP
@onready var map: Map = %Map
@onready var timer: Timer = $Timer
@onready var sfx: AudioStreamPlayer = $"../../SFX"


func _ready():
	await game.ready
	coords = game.state.cursor
	position = map.coordinates_2d_to_3d(coords, 0.5)
	if game.level.get_ai(game.state.turn) > 0:
		_ai_move()

func move_cursor():
	sfx.stop()
	sfx.play()
	timer.start()

func _process(_delta):
	if can_move:
		var move = null
		if game.state.turn == PLAYER1 and not game.level.get_ai(PLAYER1):
			move = Vector2i(
				int(Input.get_action_strength("right") - Input.get_action_strength("left")), 0
			)
		elif game.state.turn == PLAYER2 and not game.level.get_ai(PLAYER2):
			move = Vector2i(
				0, int(Input.get_action_strength("down") - Input.get_action_strength("up"))
			)
		if move:
			coords.x = clamp(coords.x + move.x, 0, 7)
			coords.y = clamp(coords.y + move.y, 0, 7)
			position = map.coordinates_2d_to_3d(coords, 0.5)
			can_move = false
			move_cursor()


func _input(event):
	if can_move and event.is_action_pressed("select"):
		selected.emit(coords)
		timer.stop()
	if can_move and event.is_action_pressed("click"):
		var click_position = -round(
			(Vector2(get_viewport().size / 2) - event.position) / 96 - Vector2(3.5, 3.5)
		)
		move_and_click(click_position)


func _ai_move():
	move_and_click(ai.calc(game.state, game.level.get_ai(game.state.turn)))


func move_and_click(move: Vector2i):
	if (
		move.x > 7
		or move.x < 0
		or move.y > 7
		or move.y < 0
		or not game.state.is_possible_move(move)
	):
		return
	var diff = move - coords
	if (game.state.turn == PLAYER1 and diff.y != 0) or (game.state.turn == PLAYER2 and diff.x != 0):
		return
	can_move = false
	if game.state.turn == PLAYER1:
		for i in range(abs(diff.x)):
			coords.x += diff.x / abs(diff.x)
			position = map.coordinates_2d_to_3d(coords, 0.5)
			move_cursor()
			await timer.timeout
	if game.state.turn == PLAYER2:
		for i in range(abs(diff.y)):
			coords.y += diff.y / abs(diff.y)
			position = map.coordinates_2d_to_3d(coords, 0.5)
			move_cursor()
			await timer.timeout
	selected.emit(coords)


func _on_timer_timeout():
	if game.level.get_ai(game.state.turn) == 0:
		can_move = true


func _on_map_turn_changed():
	if game.level.get_ai(game.state.turn) > 0:
		_ai_move()
