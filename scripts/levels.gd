extends Control

@onready var v_box_container = %Container
var game_scene = preload("res://scenes/game.tscn")

var levels = {
	0: {"player1": 0, "player2": 1, "background": "res://backgrounds/background0.png", "level": 1},
	1: {"player1": 1, "player2": 0, "background": "res://backgrounds/background1.png", "level": 2},
	2: {"player1": 0, "player2": 2, "background": "res://backgrounds/background2.png", "level": 3},
	3: {"player1": 2, "player2": 0, "background": "res://backgrounds/background3.png", "level": 4},
	4: {"player1": 0, "player2": 4, "background": "res://backgrounds/background4.png", "level": 5},
	5: {"player1": 4, "player2": 0, "background": "res://backgrounds/background0.png", "level": 6},
	6: {"player1": 0, "player2": 8, "background": "res://backgrounds/background0.png", "level": 7},
	7: {"player1": 8, "player2": 0, "background": "res://backgrounds/background0.png", "level": 8},
	8: {"player1": 0, "player2": 16, "background": "res://backgrounds/background0.png", "level": 9},
	9:
	{"player1": 16, "player2": 0, "background": "res://backgrounds/background0.png", "level": 10},
}


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		var button = Button.new()
		button.add_theme_font_size_override("font_size", 96)
		button.set_custom_minimum_size(Vector2(128, 0))
		button.text = "%s" % (i + 1)
		button.pressed.connect(_on_button_clicked.bind(i))
		v_box_container.add_child(button)


func _on_button_clicked(level):
	Global.change_scene("res://scenes/game.tscn", levels[level])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_continue_pressed():
	Global.change_scene("res://scenes/game.tscn", Global.current_game)
