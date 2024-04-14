extends Node


enum Status {ACTIVE, LOCKED, COMPLETED}

var level: Level = null
var state: State = null
var progress;


func _ready():
	progress = load_progress()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var scene = get_tree().get_current_scene()
		if get_tree().get_current_scene().get_name() == "Game":
			var game: Game = scene
			save_game(game.level, game.state)
		save_progress(progress)
		get_tree().quit()


func load_game():
	var load_game = FileAccess.open("user://game.save", FileAccess.READ)
	var data = JSON.parse_string(load_game.get_line())
	level = Level.from_dict(data["level"])
	state = State.from_dict(data["state"])


func load_progress():
	var load_progress = FileAccess.open("user://progress.save", FileAccess.READ)
	if load_progress:
		return JSON.parse_string(load_progress.get_line())
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


func save_game(level: Level, state: State):
	var save_game = FileAccess.open("user://game.save", FileAccess.WRITE)
	save_game.store_line(JSON.stringify({
		"level": level.to_dict(),
		"state": state.to_dict(),
	}))


func save_progress(progress):
	var save_progress = FileAccess.open("user://progress.save", FileAccess.WRITE)
	save_progress.store_line(JSON.stringify(progress))
