extends Node

#const SAVE_PATH = "user://data.save"
#
#var current_game: Dictionary
#var game_stats: Array
#
#
#func cords_to_position(cords: Vector2, z = 0.0):
	#return Vector3(cords.x - 4. + 0.5 - 4. / 3., -cords.y + 4. - 0.5, z)
#
#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout
#
#var _params = null
#
#
#func change_scene(next_scene, params = null):
	#_params = params
	#get_tree().change_scene_to_file(next_scene)
#
#
#func get_param(param_name, default = null):
	#if _params != null and _params.has(param_name):
		#return _params[param_name]
	#return default
#
#
#func _ready():
	#load_save()
	##print(current_game)
#
#
#func _notification(what: int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#write_save()
		#get_tree().quit()
#
#
#func get_current_game():
	#var scene = get_tree().get_current_scene()
	#var result = {}
	#if scene.name == "Game":
		#var game = scene
		#result = {
			#"map": game.map.map,
			#"turn": game.turn,
			#"cursor": game.cursor.current_cords,
			#"scores": game.scores,
			#"player1": game.player1,
			#"player2": game.player2,
			#"background": game.map.background_texture_path,
			#"step": game.step,
			#"level": game.level
		#}
	#return result
#
#
#func write_save():
	#var game = get_current_game()
	#if game:
		#current_game = game
	#var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#file.store_var(current_game)
	#file.store_var(game_stats)
#
#
#func load_save():
	#if FileAccess.file_exists(SAVE_PATH):
		#var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		#current_game = file.get_var(true)
		#game_stats = file.get_var(true)
	#else:
		#current_game = {}
		#game_stats = []
		#game_stats.resize(10)
		#game_stats.fill(0)
	#print(game_stats)
