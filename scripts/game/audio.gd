class_name Audio
extends Node


@export var game: Game
@export var music: AudioStreamPlayer
@export var move: AudioStreamPlayer
@export var select: AudioStreamPlayer


func _ready() -> void:
	await game.ready
	music.set_stream(load(game.level.music_path))
	music.play()


func play_move():
	move.stop()
	move.play()


func play_select():
	select.play()


func _on_music_finished() -> void:
	music.play()
