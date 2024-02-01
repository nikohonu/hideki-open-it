extends TextureButton
class_name CellUI

signal clicked(cords)

var cords = Vector2i.ZERO


func _on_pressed():
	clicked.emit(cords)
