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


func _on_music_finished() -> void:
	music.play()


func _on_cursor_moved() -> void:
	move.stop()
	move.play()


func _on_cursor_cell_selected(_coords: Vector2i) -> void:
	select.play()
