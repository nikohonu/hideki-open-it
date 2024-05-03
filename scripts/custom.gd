extends MarginContainer

const MAX_AI = 18
const BACKGROUNDS = {
	1: "pexels-abby-chung-1045615.webp",
	2: "pexels-casia-charlie-2425464.webp",
	3: "pexels-dsd-1829980.webp",
	4: "pexels-evgeny-tchebotarev-2235302.webp",
	5: "pexels-leeloo-the-first-5236398.webp",
	6: "pexels-matt-hardy-2031687.webp",
	7: "pexels-ryutaro-tsukata-5745864.webp",
	8: "pexels-ryutaro-tsukata-6249546.webp",
	9: "pexels-sunil-poudel-2758567.webp",
	10: "pexels-tomáš-malík-3408353.webp",
}
const MUSIC = {
	"Yugen Emotional Ethnic Music": "Yugen-Emotional-Ethnic-Music(chosic.com).mp3",
	"Yoitrax Ronin": "yoitrax-ronin(chosic.com).mp3",
	"Sakuya": "PerituneMaterial_Sakuya(chosic.com).mp3",
	"Sakuya 2": "PerituneMaterial_Sakuya2(chosic.com).mp3",
	"Sakuya 3": "PerituneMaterial_Sakuya3(chosic.com).mp3",
}

@export var music: AudioStreamPlayer
@export var background: TextureRect

@export var background_label: Label
@export var label_ai1: Label
@export var label_ai2: Label
@export var music_label: Label

@export var first_button: Control

var background_index: int:
	set(index):
		background.texture = load("res://backgrounds/" + BACKGROUNDS.values()[index])
		background_label.set_text(tr("BACKGROUND")+ " %s" % BACKGROUNDS.keys()[index])
		Global.custom.background_index = index
		background_index = index
var ai1: int:
	set(ai):
		label_ai1.set_text(ai_to_str(ai))
		Global.custom.ai1 = ai
		ai1 = ai
var ai2: int:
	set(ai):
		label_ai2.set_text(ai_to_str(ai))
		Global.custom.ai2 = ai
		ai2 = ai
var music_index: int:
	set(index):
		music.stream = load("res://music/" + MUSIC.values()[index])
		music.play()
		music_label.set_text(MUSIC.keys()[index])
		Global.custom.music_index = index
		music_index = index


func _ready():
	background_index = Global.custom.background_index
	music_index = Global.custom.music_index
	ai1 = Global.custom.ai1
	ai2 = Global.custom.ai2
	if Global.is_joypad_connected:
		first_button.grab_focus()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func ai_to_str(ai: int):
	if ai == 0:
		return tr("HUMAN")
	else:
		return tr("AI") + " - %s" % ai


func _on_prev_background_pressed():
	background_index = wrap(background_index - 1, 0, len(BACKGROUNDS))


func _on_next_background_pressed():
	background_index = wrap(background_index + 1, 0, len(BACKGROUNDS))


func _on_prev_ai_1_pressed():
	ai1 = wrap(ai1 - 2, 0, MAX_AI)


func _on_next_ai_1_pressed():
	ai1 = wrap(ai1 + 2, 0, MAX_AI)


func _on_prev_ai_2_pressed():
	ai2 = wrap(ai2 - 2, 0, MAX_AI)


func _on_next_ai_2_pressed():
	ai2 = wrap(ai2 + 2, 0, MAX_AI)


func _on_prev_music_pressed():
	music_index = wrap(music_index - 1, 0, len(MUSIC))


func _on_next_music_pressed():
	music_index = wrap(music_index + 1, 0, len(MUSIC))


func _on_start_pressed():
	Global.custom_level =  Level.from_parameters(
		"Custom",
		"res://backgrounds/" + BACKGROUNDS.values()[background_index],
		"res://music/" + MUSIC.values()[music_index],
		[ai1, ai2],
	)
	Global.current_level = -1
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
