extends Node3D

var cell_scene = preload("res://scenes/cell.tscn")
var texture_background = preload("res://backgrounds/background0.png")
var map: Array
var map_size = Vector2i(8, 8)
var cells: Array
var cell_size = Vector2(96, 96)
var cursor = Vector2(4, 3)
var start_position
var can_move = true
var scores = [0, 0]
var tween
@export var speed: float = 0.2


func check_game_end(player: Global.Player):
	var total = 0
	if player == Global.Player.FIRST:
		for x in range(map_size.x):
			total += 1 if map[cursor.y][x] != 0 else 0
	else:
		for y in range(map_size.y):
			total += 1 if map[y][cursor.x] != 0 else 0
	if total == 0:
		can_move = false
		for i in range(map_size.y):
			for j in range(map_size.x):
				if map[i][j] != 0:
					cells[i][j].select()


func cords_to_position(cords: Vector2, z):
	return Vector3(cords.x - 4 + 0.5 - (4 / 3.), cords.y - 4 + 0.5, z)


func generate_board():
	var background_size = texture_background.get_size()
	background_size /= max(background_size.x, background_size.y)
	background_size = Vector2(background_size.y, background_size.x)
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
			var cell = cell_scene.instantiate()
			cell.cords = Vector2(j, i)
			cell.position = cords_to_position(Vector2(j, i), 0)
			cell.value = map[i][j]
			cell.mesh.get_material().set_shader_parameter("texture_background", texture_background)
			cell.mesh.get_material().set_shader_parameter("size", background_size)
			#cell.connect("cell_clicked", _on_cell_click)
			cells[i].push_back(cell)
			$Map.add_child(cell)


func _ready():
	generate_board()
	$Cursor.position = cords_to_position(cursor, 0.5)


func select(player: Global.Player):
	var score = map[cursor.y][cursor.x]
	if score == 0:
		return
	$Cursor.visible = false
	can_move = false
	map[cursor.y][cursor.x] = 0
	var cell = cells[cursor.y][cursor.x]
	cell.select()
	cell.connect("animation_finished", on_select_animation_finished.bind(player, score))


func on_select_animation_finished(player: Global.Player, score):
	var oposite_player = (
		Global.Player.SECOND if player == Global.Player.FIRST else Global.Player.FIRST
	)
	if player == Global.Player.FIRST:
		computer_move()
	scores[player] += score
	$Panel.update_score(player, scores[player])
	$Panel.update_move_status(oposite_player)
	$Cursor.visible = true
	if player == Global.Player.SECOND:
		can_move = true
	check_game_end(oposite_player)


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
	var new_position = cords_to_position(cords, 0.5)
	if tween:
		tween.kill()
	tween = create_tween()
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
		select(Global.Player.FIRST)
	if can_move and input_direction.length() > 0:
		can_move = false
		cursor.x = clamp(cursor.x + input_direction.x, 0, map_size.x - 1)
		move_cursor(cursor, 1, _on_movement_tween_finished)


func _on_cell_click(cords):
	if can_move and cords.y == cursor.y:
		var diff = abs(cursor.x - cords.x)
		cursor = cords
		move_cursor(cursor, diff, _on_mouse_movement_tween_finished)


## When player 1 move with keys
func _on_movement_tween_finished():
	can_move = true


## When player 1 move with mouse
func _on_mouse_movement_tween_finished():
	select(Global.Player.FIRST)


## When computer move
func _on_computer_movement_tween_finished():
	can_move = true
	select(Global.Player.SECOND)
