extends AnimatedSprite3D

enum {PLAYER1, PLAYER2}

signal selected(Vector2i)

@onready var map: Map = %Map
@onready var timer: Timer = $Timer
@onready var ai: AI = $AI
@export var game: Game

var coords = Vector2i(4, 4)
var can_move = true



func _input(event):
	if event.is_action_pressed("select"):
		selected.emit(coords)


func _ready():
	await game.ready
	position = map.coordinates_2d_to_3d(coords, 0.5)
	if game.ai[PLAYER1] != 0:
		ai_move()


func _process(delta):
	if can_move:
		var move = null
		if game.state.turn == PLAYER1 and not game.ai[PLAYER1]:
			move = Vector2i(Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
		elif game.state.turn == PLAYER2 and not game.ai[PLAYER2]:
			move = Vector2i(0, Input.get_action_strength("down") - Input.get_action_strength("up"))
		if move:
			coords.x = clamp(coords.x + move.x, 0, 7)
			coords.y = clamp(coords.y + move.y, 0, 7)
			position = map.coordinates_2d_to_3d(coords, 0.5)
			can_move = false
			timer.start()


func ai_move():
	var dest = ai.calc(game.state, game.ai[game.state.turn])
	var diff = dest - coords
	if game.state.turn == PLAYER1:
		for i in range(abs(diff.x)):
			var sign = diff.x/abs(diff.x)
			coords.x += sign
			position = map.coordinates_2d_to_3d(coords, 0.5)
			timer.start()
			await timer.timeout
	if game.state.turn == PLAYER2:
		for i in range(abs(diff.y)):
			var sign = diff.y/abs(diff.y)
			coords.y += sign
			position = map.coordinates_2d_to_3d(coords, 0.5)
			timer.start()
			await timer.timeout
	selected.emit(coords)


func _on_timer_timeout():
	can_move = true


func _on_game_turn_changed():
	if game.ai[game.state.turn] > 0:
		ai_move()
