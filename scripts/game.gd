extends Node2D

var cell_scene = preload("res://scenes/cell.tscn")
var cell_size = Vector2(96, 96)
var map_size = Vector2i(8, 8)
var map: Array
var cells: Array
var cursor = Vector2i(4, 4)
var start_position
var can_move = true
var p1_score = 0
var p2_score = 0
@export var speed: float = 0.1
enum Player { FIRST, SECOND }


func cords_to_position(cords: Vector2i):
	return Vector2(
		start_position.x + (cell_size.x * cords.x), start_position.y + (cell_size.y * cords.y)
	)


func generate_board():
	var possible_value = []
	for i in range(1, 12):
		for j in range(3):
			possible_value.push_back(-i)
			possible_value.push_back(i)
	possible_value.shuffle()
	for i in range(map_size.y):
		map.append([])
		cells.append([])
		for j in range(map_size.x):
			map[i].push_back(possible_value.pop_front())
			var cell: Node2D = cell_scene.instantiate()
			cell.cords = Vector2i(j, i)
			cell.position = cords_to_position(cell.cords)
			cell.value = map[i][j]
			cell.connect("cell_clicked", _on_cell_click)
			cells[i].push_back(cell)
			$Map.add_child(cell)


func _ready():
	var size = get_viewport().get_visible_rect().size
	var center = Vector2(size.x / 2 - 128, size.y / 2)
	start_position = Vector2(
		center.x - cell_size.x * (map_size.x / 2), center.y - cell_size.y * (map_size.y / 2)
	)
	$Cursor.position = cords_to_position(cursor)
	generate_board()


func select(player: Player):
	var score = map[cursor.y][cursor.x]
	if score == 0:
		return
	map[cursor.y][cursor.x] = 0
	cells[cursor.y][cursor.x].value = 0
	if player == Player.FIRST:
		p1_score += score
		can_move = false
		computer_move()
	else:
		p2_score += score


func calculate_computer_move():
	var best = -99
	var best_position = 0
	var new_cursor = Vector2i(cursor)
	for i in range(map_size.x):
		if map[i][new_cursor.x] == 0:
			continue
		if map[i][new_cursor.x] > best:
			best_position = i
			best = map[i][new_cursor.x]
	new_cursor.y = best_position
	return new_cursor


func move_cursor(cords: Vector2i, diff: int, on_tween_finished):
	var new_position = cords_to_position(cords)
	var tween = create_tween()
	tween.finished.connect(on_tween_finished)
	tween.tween_property($Cursor, "position", new_position, speed * diff).set_trans(
		Tween.TRANS_CUBIC
	)


func computer_move():
	var new_cursor = calculate_computer_move()
	var diff = abs(cursor.y - new_cursor.y)
	cursor = new_cursor
	move_cursor(cursor, diff, _on_computer_movement_tween_finished)


func _process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_just_released("ui_accept"):
		select(Player.FIRST)
	if can_move and input_direction.length() > 0:
		can_move = false
		cursor.x = clamp(cursor.x + input_direction.x, 0, map_size.x - 1)
		move_cursor(cursor, 1, _on_movement_tween_finished)


func _on_cell_click(cords):
	if can_move and cords.y == cursor.y:
		var diff = abs(cursor.x - cords.x)
		cursor = cords
		move_cursor(cursor, diff, _on_mouse_movement_tween_finished)


# When player 1 move with keys
func _on_movement_tween_finished():
	can_move = true


# When player 1 move with mouse
func _on_mouse_movement_tween_finished():
	select(Player.FIRST)


# When computer move
func _on_computer_movement_tween_finished():
	can_move = true
	select(Player.SECOND)
