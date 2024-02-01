extends AnimatedSprite3D

@onready var game: Game = get_tree().get_current_scene()
@onready var map = %Map
@export_range(0.1, 2, 0.1) var speed = 1.0

var can_move = true
var current_cords = Vector2i(4, 4)
var tween: Tween


func _ready():
	position = Global.cords_to_position(current_cords, 0.5)


func select():
	var value = map.map[current_cords.y][current_cords.x]
	var cell = map.cells[current_cords.y][current_cords.x]
	if value == 0:
		return
	game.add_score(game.turn, value)
	var turn = game.next_turn()
	map.map[current_cords.y][current_cords.x] = 0
	var end = map.check_end(turn, current_cords)
	cell.connect("animation_finished", after_select.bind(end))
	cell.select()
	can_move = false
	visible = false


func after_select(end):
	if not end:
		can_move = true
		visible = true
	else:
		for y in range(map.SIZE):
			for x in range(map.SIZE):
				if map.map[y][x] != 0:
					map.map[y][x] = 0
					map.cells[y][x].select()


func move(cords: Vector2i, absolute, select_on_finish):
	if absolute:
		if cords.y != current_cords.y and game.turn == Game.Player.FIRST:
			return
		if cords.x != current_cords.x and game.turn == Game.Player.SECOND:
			return
	var target_cords = current_cords
	if game.turn == Game.Player.FIRST:
		target_cords.x = cords.x if absolute else target_cords.x + cords.x
		target_cords.x = clamp(target_cords.x, 0, 7)
	else:
		target_cords.y = cords.y if absolute else target_cords.y + cords.y
		target_cords.y = clamp(target_cords.y, 0, 7)
	var diff = (
		abs(target_cords.x - current_cords.x)
		if game.turn == Game.Player.FIRST
		else abs(target_cords.y - current_cords.y)
	)
	var target_position = Global.cords_to_position(target_cords, 0.5)
	can_move = false
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", target_position, (0.15 / speed) * diff).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.finished.connect(on_tween_finished.bind(select_on_finish))
	current_cords = target_cords


func on_tween_finished(select_on_finish):
	can_move = true
	if select_on_finish:
		select()


func _on_map_ui_cell_clicked(cords):
	if can_move:
		move(cords, true, true)


func _process(_delta):
	if can_move:
		if Input.is_action_just_released("select"):
			select()
		var input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		if input.length() != 0:
			move(input, false, false)
