class_name Game
extends Node3D

signal state_changed(new_state: State)
signal game_ended(winner: int)

var ai = []
var state: State = null

@onready var cursor = $Map/Cursor
@onready var level: Level
@onready var map: Map = %Map
@onready var ui: UI = $UI


func _ready():
	if Global.should_load_saved_state:
		state = Global.saved_state
		Global.saved_state = null
		Global.should_load_saved_state = false
	else:
		state = State.new()
	if Global.current_level >= 0:
		level = Global.levels[Global.current_level]
	state.game_ended.connect(_on_state_game_ended)
	state.state_changed.connect(_on_state_changed)
	


func restart():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func next_level():
	if Global.current_level < len(Global.levels) - 1:
		Global.current_level += 1
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_choose_level_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")


func _on_change_settings_pressed():
	Global.level = Global.prev_level
	Global.state = Global.prev_state
	get_tree().change_scene_to_file("res://scenes/custom.tscn")


func _on_cursor_cell_selected(coords: Vector2i) -> void:
	state.select(coords)


func _on_state_changed(new_state):
	state_changed.emit(new_state)


func _on_state_game_ended(winner):
	game_ended.emit(winner)
	cursor.can_move = false
	$UI/PanelContainer.visible = true
	if Global.current_level == len(Global.levels):
		$UI/PanelContainer/MarginContainer/Win/HBoxContainer/NextLevel.visible = false
	if Global.current_level >= 0:
		if Global.current_level % 2 == 0:
			if winner == 1:
				_mark_complete()
				$UI/PanelContainer/MarginContainer/Win.visible = true
			else:
				$UI/PanelContainer/MarginContainer/Lose.visible = true
		else:
			if winner == 0:
				_mark_complete()
				$UI/PanelContainer/MarginContainer/Win.visible = true
			else:
				$UI/PanelContainer/MarginContainer/Lose.visible = true
	else:
		$UI/PanelContainer/MarginContainer/Custom/Label.set_text("Players %s win!" % (winner + 1))
		$UI/PanelContainer/MarginContainer/Custom.visible = true


func _mark_complete():
	if Global.current_level == Global.progress:
		Global.progress += 1
		Global.save_game()
