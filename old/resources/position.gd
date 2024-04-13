class_name Position
extends Resource

const SIZE = 8

@export var map: Array
@export var cords: Vector2i
@export var player: Game.Player
@export var scores: Array

func get_children():
	pass

func _init(map, cords, player, scores):
	self.map = map.duplicate(true)
	self.cords = cords
	self.player = player
	self.scores = scores.duplicate()

func select():
	self.scores[player] += self.map[cords.y][cords.x]
	player = Game.Player.FIRST if player == Game.Player.SECOND else Game.Player.SECOND
	self.map[cords.y][cords.x] = 0

func eval():
	return scores[0] - scores[1]

	
func children():
	var result = []
	if player == Game.Player.FIRST:
		for i in range(SIZE):
			if map[cords.y][i] != 0:
				var position = Position.new(map, Vector2i(i, cords.y), player, scores)
				position.select()
				result.push_back(position)
	if player == Game.Player.SECOND:
		for i in range(SIZE):
			if map[i][cords.x] != 0:
				var position = Position.new(map, Vector2i(cords.x, i), player, scores)
				position.select()
				result.push_back(position)
	return result
