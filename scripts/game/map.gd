class_name Map
extends Node3D

signal turn_changed

@export var game: Game
@export var arrows: Array[AnimatedSprite2D]

var CellScene = preload("res://scenes/cell.tscn")
var cells: Dictionary
var background: CompressedTexture2D

@onready var cursor: Cursor = $Cursor


func _ready() -> void:
	await game.ready
	background = load(game.level.background_path)
	for y in range(8):
		for x in range(8):
			add_cell(CellScene, Vector2i(x, y), game.state.map[y][x])
	_highlight_possible_moves()


func _highlight_possible_moves():
	var center = Vector2i(get_viewport().size / 2)
	var cell_size = 96
	for i in range(8):
		for j in range(8):
			cells[Vector2i(i, j)].set_active(false)
	if game.state.turn == State.PLAYER1:
		arrows[0].position.x = center.x - 4 * cell_size - cell_size / 2
		arrows[1].position.x = center.x + 4 * cell_size + cell_size / 2
		arrows[0].position.y = center.y - (cell_size * 4) + cell_size * game.state.cursor.y + cell_size / 2
		arrows[1].position.y = center.y - (cell_size * 4) + cell_size * game.state.cursor.y + cell_size / 2
		arrows[0].rotation = 0
		arrows[1].rotation = PI
		for i in range(8):
			cells[Vector2i(i, game.state.cursor.y)].set_active(true)
	if game.state.turn == State.PLAYER2:
		arrows[0].position.y = center.y - 4 * cell_size - cell_size / 2
		arrows[1].position.y = center.y + 4 * cell_size + cell_size / 2
		arrows[0].position.x = center.x - (cell_size * 4) + cell_size * game.state.cursor.x + cell_size / 2
		arrows[1].position.x = center.x - (cell_size * 4) + cell_size * game.state.cursor.x + cell_size / 2
		arrows[0].rotation = PI / 2
		arrows[1].rotation = PI / 2 * 3
		for i in range(8):
			cells[Vector2i(game.state.cursor.x, i)].set_active(true)


func coordinates_2d_to_3d(coordinates: Vector2i, z = 0.0):
	return Vector3(coordinates.x - 3.5, 3.5 - coordinates.y, z)


func add_cell(cell_scene: PackedScene, cell_position: Vector2i, value: int):
	var cell = cell_scene.instantiate()
	cell.position = coordinates_2d_to_3d(cell_position)
	cell.set_state(cell_position, value, background, _get_background_aspect_ratio())
	cells[cell_position] = cell
	if value == 0:
		cell.select(true)
	cell.animation_finished.connect(_on_cell_animation_finished)
	add_child(cell)


func _get_background_aspect_ratio():
	var background_size = background.get_size()
	return Vector2(background_size.y, background_size.x) / max(background_size.x, background_size.y)


func _on_cell_animation_finished():
	cursor.can_move = true
	cursor.visible = true
	turn_changed.emit()
	_highlight_possible_moves()


func _on_cursor_cell_selected(coords: Vector2i) -> void:
	if coords in cells:
		cells[coords].select()
	else:
		print("Coords not in cells")
