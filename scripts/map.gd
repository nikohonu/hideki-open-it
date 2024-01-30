extends Node3D

const SIZE = 8

@export var background_texture: CompressedTexture2D

var cell_scene = preload("res://scenes/cell.tscn")

var map = []
var cells = []


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
			cell.set_state(Vector2i(x, y), map[y][x], background_texture, ratio)
			cells[y].push_back(cell)
			add_child(cell)


func _ready():
	var possible_values = _generate_possible_values()
	for i in range(SIZE):
		var start = i * SIZE
		map.append(possible_values.slice(start, start + SIZE))
	_draw_map()
