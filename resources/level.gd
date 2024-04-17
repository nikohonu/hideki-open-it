class_name Level
extends Resource


enum PlayerType {
	HUMAN = 0,
	AI_EASY = 1,
	AI_MEDIUM = 4,
	AI_HARD = 8,
	AI_EXPERT = 16,
}

@export var background: CompressedTexture2D
@export var player1: PlayerType
@export var player2: PlayerType
@export var music: AudioStreamMP3
@export var name: String
@export var progress: int


func get_ai(player):
	if player == State.PLAYER1:
		return player1
	else:
		return player2
	

static func load_custom(background_path, player1_type: PlayerType, player2_type: PlayerType, music_path, name: String):
	var level = Level.new()
	level.background = load(background_path)
	level.player1 = player1_type
	level.player2 = player2_type
	level.music = load(music_path)
	level.name = name
	level.progress = 0
	return level


static func from_dict(dict: Dictionary):
	if dict.has("path"):
		return load(dict["path"])
	else:
		return load_custom(
			dict["background_path"], 
			dict["player1"],
			dict["player2"],
			dict["music_path"],
			dict["name"],
		)


func to_dict():
	var path = self.get_path()
	if path:
		return {"path": path}
	else:
		return {
			"background_path": self.background.get_path(),
			"player1": self.player1,
			"player2": self.player2,
			"music_path": self.music.get_path(),
			"name": self.name,
		}
