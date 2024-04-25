extends Node


const STATE_SAVE_PATH = "user://state.json"
const GAME_SAVE_PATH = "user://save.dat"
const LEVEL_COUNT = 18

var levels: Array[Level]
var progress: int = 0
var saved_level: int = -1
var saved_state: State = null
var should_load_saved_state: bool = false
var current_level: int = -1
var custom_level: Level
var custom = {
	"background_index": 0,
	"music_index": 0,
	"ai1": 0,
	"ai2": 0,
}


func _ready():
	for i in range(LEVEL_COUNT):
		levels.append(load("res://levels/level%s.tres" % (i + 1)))
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
	saved_state = current_state


func load_state():
	var state_save_file = FileAccess.open(STATE_SAVE_PATH, FileAccess.READ)
	if state_save_file:
		saved_state = State.from_dict(JSON.parse_string(state_save_file.get_line()))


func reset_state():
	DirAccess.remove_absolute(STATE_SAVE_PATH)
	saved_state = null
	saved_level = -1


func reset_game():
	DirAccess.remove_absolute(STATE_SAVE_PATH)
	progress = 0


func is_custom_level():
	return current_level == -1 


func load_level():
	if is_custom_level():
		return custom_level
	else:
		return levels[current_level]


func coordinates_2d_to_3d(coordinates: Vector2i, z = 0.0):
	return Vector3(coordinates.x - 3.5, 3.5 - coordinates.y, z)
