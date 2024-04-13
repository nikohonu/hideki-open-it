extends Node3D
class_name Map

var cells: Dictionary


func coordinates_2d_to_3d(coordinates: Vector2i, z = 0.0):
	return Vector3(coordinates.x - 3.5, 3.5 - coordinates.y, z)


func add_cell(cell_scene: PackedScene, position: Vector2i, value: int):
	var cell = cell_scene.instantiate()
	cell.position = coordinates_2d_to_3d(position)
	cell.value = value
	cells[position] = cell
	add_child(cell)


func select(coords: Vector2i):
	cells[coords].value = 0


func _ready():
	pass


func _process(delta):
	pass
