class_name Game
extends Node3D


signal state_changed(new_state: State)
signal ended(winner: int, is_player_win: bool)

var state: State
var level: Level
var is_ended: bool = false


func _ready():
	if Global.should_load_saved_state:
		state = Global.saved_state
		Global.saved_state = null
		Global.should_load_saved_state = false
	else:
		state = State.new()
	level = Global.load_level()
	state.game_ended.connect(_on_state_game_ended)
	state.selected.connect(_on_state_changed)


func restart():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func next_level():
	if Global.current_level < len(Global.levels) - 1:
		Global.current_level += 1
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func back():
	if Global.is_custom_level():
		get_tree().change_scene_to_file("res://scenes/custom.tscn")
	else:
		if not is_ended:
			Global.save_state(state)
			Global.saved_level = Global.current_level
			Global.save_game()
		else:
			Global.reset_state()
		get_tree().change_scene_to_file("res://scenes/level_selection/level_selection.tscn")


func _on_state_changed(new_state):
	state_changed.emit(new_state)


func _on_state_game_ended(winner):
	var is_player_win := level.ai[winner] == 0
	is_ended = true
	ended.emit(winner, is_player_win)
	if Global.current_level >= 0 and is_player_win:
		if Global.current_level == Global.progress:
			Global.progress += 1
			Global.saved_level = -1
			Global.save_game()


func _on_cursor_cell_selected(coords: Vector2i) -> void:
	state.select(coords)
