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
	level.ai = _ai
	return level
	
static func from_dict(dict: Dictionary):
	if dict.has("path"):
		return load(dict["path"])
	else:
		return from_parameters(
			dict["name"],
			dict["background_path"], 
			dict["music_path"],
			dict["ai"],
		)


func to_dict():
	var path = self.get_path()
	if path:
		return {"path": path}
	else:
		return {
			"name": self.name,
			"background_path": self.background.get_path(),
			"music_path": self.music.get_path(),
			"ai": self.ai,
		}
