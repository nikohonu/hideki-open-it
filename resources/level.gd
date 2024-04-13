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
