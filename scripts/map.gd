class_name Map
extends Node3D

signal turn_changed

@export var game: Game

var cells: Dictionary

@onready var cursor: Cursor = $Cursor


func coordinates_2d_to_3d(coordinates: Vector2i, z = 0.0):
	return Vector3(coordinates.x - 3.5, 3.5 - coordinates.y, z)


func add_cell(cell_scene: PackedScene, cell_position: Vector2i, value: int):
	var cell = cell_scene.instantiate()
	cell.position = coordinates_2d_to_3d(cell_position)
	cell.set_state(cell_position, value, game.level.background, _get_background_aspect_ratio())
	cells[cell_position] = cell
	if value == 0:
		cell.select(true)
	cell.animation_finished.connect(_on_cell_animation_finished)
	add_child(cell)


func select(coords: Vector2i):
	cells[coords].select()
	cursor.can_move = false
	cursor.visible = false


func _get_background_aspect_ratio():
	var background_size = game.level.background.get_size()
	return Vector2(background_size.y, background_size.x) / max(background_size.x, background_size.y)


func _on_cell_animation_finished():
	cursor.can_move = true
	cursor.visible = true
	turn_changed.emit()
