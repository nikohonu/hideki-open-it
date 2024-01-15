extends AnimatedSprite3D

@export var speed: float = 0.15
@onready var game = get_tree().get_current_scene()

var can_move = true
var tween: Tween

var cords: Vector2:
	set(c):
		c.x = clamp(c.x, 0, 7)
		c.y = clamp(c.y, 0, 7)
		cords = c


func _ready():
	cords = Vector2(4, 3)
	position = Global.cords_to_position(cords, 0.5)
	if game.is_player_ai[0] == true:
		ai_move()


func move(diff = 1, select = false):
	can_move = false
	var target_position = Global.cords_to_position(cords, 0.5)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", target_position, speed * diff).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.finished.connect(on_tween_finished.bind(select))
	
func on_tween_finished(select = false):
	can_move = true
	if select:
		select_cell()


func check_game_end():
	var total = 0
	if game.current_player == game.Player.FIRST:
		for x in range(%Map.size):
			total += 1 if %Map.map[cords.y][x].value != 0 else 0
	else:
		for y in range(%Map.size):
			total += 1 if %Map.map[y][cords.x].value != 0 else 0
	if total == 0:
		print("end")
		can_move = false
		for i in range(%Map.size):
			for j in range(%Map.size):
				if %Map.map[i][j].value != 0:
					%Map.map[i][j].select()


func select_cell():
	var cell = %Map.map[cords.y][cords.x]
	if cell.value == 0:
		return
	game.update_score(game.current_player, cell.value)
	cell.value = 0
	cell.connect("animation_finished", after_select)
	cell.select()
	can_move = false
	visible = false


func after_select():
	visible = true
	can_move = true
	if game.current_player == game.Player.FIRST:
		game.current_player = game.Player.SECOND
	else:
		game.current_player = game.Player.FIRST
	if game.is_player_ai[game.current_player]:
		ai_move()
	check_game_end()


func process_input(input, select = false):
	if can_move:
		var diff: int
		if game.current_player == game.Player.FIRST:
			cords.x += input.x
			diff = abs(input.x)
		elif game.current_player == game.Player.SECOND:
			cords.y += input.y
			diff = abs(input.y)
		move(diff, select)


func _process(_delta):
	if Input.is_action_just_released("select"):
		select_cell()
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	)
	if game.is_player_ai[game.Player.FIRST] and input.x != 0:
		return
	if game.is_player_ai[game.Player.SECOND] and input.y != 0:
		return
	process_input(input)


func on_mouse_click(click_cords: Vector2):
	var input = click_cords - cords
	process_input(input, true)


func ai_move():
	var target_cords: Vector2
	var best_value = -INF
	var best_move = 0
	var move_cord = 0
	for i in range(%Map.size):
		var cell: Object
		cell = (
			%Map.map[cords.y][i]
			if game.current_player == game.Player.FIRST
			else %Map.map[i][cords.x]
		)
		if cell.value == 0:
			move_cord += 1
			continue
		if cell.value > best_value:
			best_value = cell.value
			best_move = move_cord
		move_cord += 1
	target_cords = (
		Vector2(best_move, cords.y)
		if game.current_player == game.Player.FIRST
		else Vector2(cords.x, best_move)
	)
	var input = target_cords - cords
	process_input(input, true)
