extends MarginContainer

@export var backgrounds: Array[Texture2D]
@export var music: Array[AudioStreamMP3]

var current_background_index: int = 0
var current_music_index: int = 0
var current_player_1: int = Level.PlayerType.HUMAN
var current_player_2: int = Level.PlayerType.HUMAN

@onready var music_dict = {
	"res://music/Yugen-Emotional-Ethnic-Music(chosic.com).mp3": "Yugen Emotional Ethnic Music",
	"res://music/yoitrax-ronin(chosic.com).mp3": "Yoitrax Ronin",
	"res://music/PerituneMaterial_Sakuya(chosic.com).mp3": "Sakuya",
	"res://music/PerituneMaterial_Sakuya2(chosic.com).mp3": "Sakuya 2",
	"res://music/PerituneMaterial_Sakuya3(chosic.com).mp3": "Sakuya 3",
}


func _ready():
	%AudioStreamPlayer.stream = music[0]
	%AudioStreamPlayer.play()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_prev_background_pressed():
	current_background_index = max(current_background_index - 1, 0)
	%Background.texture = backgrounds[current_background_index]


func _on_next_background_pressed():
	current_background_index = min(current_background_index + 1, len(backgrounds) - 1)
	%Background.texture = backgrounds[current_background_index]


func int_to_str_player(player: int):
	var player_type = Level.PlayerType.keys()[player]
	match player_type:
		"HUMAN":
			return "Human"
		"AI_EASY":
			return "AI Easy"
		"AI_MEDIUM":
			return "AI Medium"
		"AI_HARD":
			return "AI Hard"
		"AI_EXPERT":
			return "AI Expert"


func _on_prev_player_1_pressed():
	current_player_1 = max(current_player_1 - 1, 0)
	%LabelPlayer1State.set_text(int_to_str_player(current_player_1))


func _on_next_player_1_pressed():
	current_player_1 = min(current_player_1 + 1, 4)
	%LabelPlayer1State.set_text(int_to_str_player(current_player_1))


func _on_prev_player_2_pressed():
	current_player_2 = max(current_player_2 - 1, 0)
	%LabelPlayer2State.set_text(int_to_str_player(current_player_2))


func _on_next_player_2_pressed():
	current_player_2 = min(current_player_2 + 1, 4)
	%LabelPlayer2State.set_text(int_to_str_player(current_player_2))


func _on_prev_music_pressed():
	current_music_index = max(current_music_index - 1, 0)
	%LabelMusicState.set_text(music_dict[music[current_music_index].get_path()])
	%AudioStreamPlayer.stream = music[current_music_index]
	%AudioStreamPlayer.play()


func _on_next_music_pressed():
	current_music_index = min(current_music_index + 1, len(music) - 1)
	%LabelMusicState.set_text(music_dict[music[current_music_index].get_path()])
	%AudioStreamPlayer.stream = music[current_music_index]
	%AudioStreamPlayer.play()


func _on_start_pressed():
	var player_type_1 = Level.PlayerType.keys()[current_player_1]
	var player_type_2 = Level.PlayerType.keys()[current_player_2]
	var level = (
		Level
		. load_custom(
			backgrounds[current_background_index].get_path(),
			Level.PlayerType.get(player_type_1),
			Level.PlayerType.get(player_type_2),
			music[current_music_index].get_path(),
			"Custom",
		)
	)
	Global.prev_level = Global.level
	Global.prev_state = Global.state
	Global.level = level
	Global.state = null
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
