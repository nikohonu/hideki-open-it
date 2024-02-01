extends Node3D

const SIZE = 8

@export var background_texture: CompressedTexture2D
@export var cell_scene: PackedScene

@onready var map_ui: MapUI = %MapUI

var map = []
var cells = []


func check_end(turn: Game.Player, cords: Vector2i, current_map = null):
	if current_map == null:
		current_map = map
	var total = 0
	if turn == Game.Player.FIRST:
		for x in range(SIZE):
			total += 1 if current_map[cords.y][x] != 0 else 0
	else:
		for y in range(SIZE):
			total += 1 if current_map[y][cords.x] != 0 else 0
	return total == 0


func _generate_possible_values() -> Array:
	var possible_values = []
	for value in range(1, 12):
		for _i in range(3):
			possible_values += [value, -value]
	possible_values.shuffle()
	return possible_values.slice(0, SIZE ** 2)


func get_background_aspect_ratio():
	var background_size = background_texture.get_size()
	return Vector2(background_size.y, background_size.x) / max(background_size.x, background_size.y)


func _draw_map():
	var ratio = get_background_aspect_ratio()
	for y in range(SIZE):
		cells.append([])
		for x in range(SIZE):
			var cell = cell_scene.instantiate()
			var cords = Vector2i(x, y)
			cell.set_state(cords, map[y][x], background_texture, ratio)
			cells[y].push_back(cell)
			add_child(cell)
			map_ui.add_cell(cords)


func _ready():
	var possible_values = _generate_possible_values()
	for i in range(SIZE):
		var start = i * SIZE
		map.append(possible_values.slice(start, start + SIZE))
	_draw_map()
