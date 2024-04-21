class_name Map
extends Node3D


signal cell_animation_finished

@export var game: Game
@export var arrows: Array[AnimatedSprite2D]

var cells: Dictionary
var highlighted_cells: Array

const CELL_SIZE = 96


func _ready() -> void:
	await game.ready
	var CellScene = preload("res://scenes/game/cell.tscn")
	var background: CompressedTexture2D = load(game.level.background_path)
	var size = background.get_size()
	var aspect_ratio = Vector2(size.y, size.x) / max(size.x, size.y)
	for y in range(8):
		for x in range(8):
			var cell_position = Vector2i(x, y)
			var cell = CellScene.instantiate()
			cell.setup(cell_position, game.state.map[y][x], background, aspect_ratio)
			cells[cell_position] = cell
			if game.state.map[y][x] == 0:
				cell.select(true)
			cell.animation_finished.connect(_on_cell_animation_finished)
			add_child(cell)
	_highlight_possible_moves()
	ready.emit()





func _highlight_possible_moves():
	var center = Vector2i(get_viewport().size / 2)
	var cursor = game.state.cursor
	while not highlighted_cells.is_empty():
		highlighted_cells.pop_back().active = false
	if game.state.turn == State.PLAYER1:
		@warning_ignore("integer_division")
		var y_offset = center.y - (CELL_SIZE * 4) + CELL_SIZE * cursor.y + CELL_SIZE / 2
		@warning_ignore("integer_division")
		arrows[0].position = Vector2(center.x - 4 * CELL_SIZE - CELL_SIZE / 2, y_offset)
		@warning_ignore("integer_division")
		arrows[1].position = Vector2(center.x + 4 * CELL_SIZE + CELL_SIZE / 2, y_offset)
		arrows[0].rotation = 0
		arrows[1].rotation = PI
		for i in range(8):
			cells[Vector2i(i, cursor.y)].active = true
			highlighted_cells.append(cells[Vector2i(i, cursor.y)])
	elif game.state.turn == State.PLAYER2:
		@warning_ignore("integer_division")
		var x_offset = center.x - (CELL_SIZE * 4) + CELL_SIZE * cursor.x + CELL_SIZE / 2
		@warning_ignore("integer_division")
		arrows[0].position = Vector2(x_offset, center.y - 4 * CELL_SIZE - CELL_SIZE / 2)
		@warning_ignore("integer_division")
		arrows[1].position = Vector2(x_offset, center.y + 4 * CELL_SIZE + CELL_SIZE / 2)
		arrows[0].rotation = PI / 2
		arrows[1].rotation = PI / 2 * 3
		for i in range(8):
			cells[Vector2i(cursor.x, i)].active = true
			highlighted_cells.append(cells[Vector2i(cursor.x, i)])


func _on_cell_animation_finished():
	cell_animation_finished.emit()
	_highlight_possible_moves()


func _on_cursor_cell_selected(coords: Vector2i) -> void:
	cells[coords].select()
