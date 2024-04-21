extends Node

const STATE_SAVE_PATH = "user://state.json"
const GAME_SAVE_PATH = "user://save.dat"

const levels: Array[Level] = [
	preload("res://levels/level1.tres"),
	preload("res://levels/level2.tres"),
	preload("res://levels/level3.tres"),
	preload("res://levels/level4.tres"),
	preload("res://levels/level5.tres"),
	preload("res://levels/level6.tres"),
	preload("res://levels/level7.tres"),
	preload("res://levels/level8.tres"),
	preload("res://levels/level9.tres"),
	preload("res://levels/level10.tres"),
	preload("res://levels/level11.tres"),
	preload("res://levels/level12.tres"),
	preload("res://levels/level13.tres"),
	preload("res://levels/level14.tres"),
	preload("res://levels/level15.tres"),
	preload("res://levels/level16.tres"),
	preload("res://levels/level17.tres"),
	preload("res://levels/level18.tres"),
]


var progress: int = 0
var saved_level: int = -1
var saved_state: State = null
var should_load_saved_state: bool = false

var current_level: int = -1


func _ready():
	load_game()
	load_state()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var scene = get_tree().get_current_scene()
		if get_tree().get_current_scene().get_name() == "Game":
			var game: Game = scene
			save_state(game.state)
		save_game()
		get_tree().quit()


func save_game():
	var game_save_file = FileAccess.open(GAME_SAVE_PATH, FileAccess.WRITE)
	game_save_file.store_8(progress)
	game_save_file.store_64(saved_level)


func load_game():
	var game_save_file = FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
	if game_save_file:
		progress = game_save_file.get_8()
		saved_level = game_save_file.get_64()


func save_state(current_state: State):
	var state_save_file = FileAccess.open(STATE_SAVE_PATH, FileAccess.WRITE)
	state_save_file.store_line(JSON.stringify(current_state.to_dict()))
	Global.saved_state = current_state


func load_state():
	var state_save_file = FileAccess.open(STATE_SAVE_PATH, FileAccess.READ)
	if state_save_file:
		saved_state = State.from_dict(JSON.parse_string(state_save_file.get_line()))


func reset_save():
	OS.move_to_trash(ProjectSettings.globalize_path(Global.GAME_SAVE_PATH))
	Global.state = null


func is_custom_level():
	return Global.current_level == -1 
