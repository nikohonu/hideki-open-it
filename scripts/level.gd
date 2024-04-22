class_name Level
extends Resource


@export var name: String
@export_file("*.webp") var background_path
@export_file("*.mp3") var music_path
@export var ai: Array[int] = [0, 0]


static func from_parameters(_name: String, _background_path: String, _music_path: String, _ai: Array):
	var level = Level.new()
	level.name = _name
	level.background_path = _background_path
	level.music_path = _music_path
	level.ai[0] = _ai[0]
	level.ai[1] = _ai[1]
	return level
