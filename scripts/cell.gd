extends Node2D

signal cell_clicked(cords)

var cords = Vector2i.ZERO
var value: int:
	get:
		return value
	set(i):
		value = i
		if value == 0:
			visible = false
		elif value < 0:
			$Sprite2D.frame = 0
		else:
			$Sprite2D.frame = 1
		$Label.text = str(abs(i))


func _ready():
	pass


func _process(delta):
	pass


func _on_texture_button_pressed():
	cell_clicked.emit(cords)
