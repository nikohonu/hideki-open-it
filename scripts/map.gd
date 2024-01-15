extends Node3D

@export var background_texture: CompressedTexture2D

var cell_scene = preload("res://scenes/cell.tscn")
var map = []
var size = 8


func generate_possible_values() -> Array:
	var possible_values = []
	var cells_count = size * size
	var cell_count = 6.0
	var cell_type_count = round(cells_count / cell_count)
	for value in range(1, cell_type_count + 1):
		for i in range(cell_count / 2):
			possible_values += [value, -value]
	possible_values.shuffle()
	return possible_values.slice(0, cells_count)


func get_background_aspect_ratio():
	var background_size = background_texture.get_size()
	return Vector2(background_size.y, background_size.x) / max(background_size.x, background_size.y)


func _ready():
	var possible_values = generate_possible_values()
	var ratio = get_background_aspect_ratio()
	for y in range(size):
		map.append([])
		for x in range(size):
			var cell = cell_scene.instantiate()
			cell.cords = Vector2(x, y)
			cell.value = possible_values.pop_back()
			cell.mesh.get_material().set_shader_parameter("texture_background", background_texture)
			cell.mesh.get_material().set_shader_parameter("ratio", ratio)
			map[y].push_back(cell)
			add_child(cell)
