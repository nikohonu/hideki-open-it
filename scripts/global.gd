extends Node


var level: Level = null
var state: State = null

# load
#var load_game = FileAccess.open("user://game.save", FileAccess.READ)
#state.from_dict(JSON.parse_string(load_game.get_line()))
#cursor.coords = state.cursor

# save
#func _notification(what):
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#var save_game = FileAccess.open("user://game.save", FileAccess.WRITE)
		#save_game.store_line(JSON.stringify(state.to_dict()))
		#get_tree().quit()
