extends Node

const GAME_SAVE_PATH = "user://game.save"

enum Status { ACTIVE, LOCKED, COMPLETED }

var level: Level = null
var prev_level: Level = null
var prev_state: State = null
var progress
var state: State = null


func _ready():
	progress = load_progress()
	load_game()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var scene = get_tree().get_current_scene()
		if get_tree().get_current_scene().get_name() == "Game":
			var game: Game = scene
			save_game(game.level, game.state)
		save_progress()
		get_tree().quit()


func load_game():
	var game_save_file = FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
	if game_save_file:
		var data = JSON.parse_string(game_save_file.get_line())
		level = Level.from_dict(data["level"])
		state = State.from_dict(data["state"])


func load_progress():
	var load_progress_file = FileAccess.open("user://progress.save", FileAccess.READ)
	if load_progress_file:
		return JSON.parse_string(load_progress_file.get_line())
	else:
		return [
			Status.ACTIVE,
			Status.LOCKED,
			Status.LOCKED,
			Status.LOCKED,
			Status.LOCKED,
			Status.LOCKED,
			Status.LOCKED,
			Status.LOCKED,
		]


func save_game(current_level: Level, current_state: State):
	level = current_level
	state = current_state
	var save_game_file = FileAccess.open("user://game.save", FileAccess.WRITE)
	(
		save_game_file
		. store_line(
			(
				JSON
				. stringify(
					{
						"level": current_level.to_dict(),
						"state": current_state.to_dict(),
					}
				)
			)
		)
	)


func save_progress():
	var save_progress_file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	save_progress_file.store_line(JSON.stringify(progress))


func reset_save():
	OS.move_to_trash(ProjectSettings.globalize_path(Global.GAME_SAVE_PATH))
	Global.state = null
