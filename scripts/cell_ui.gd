extends TextureButton

signal cell_clicked(cords)

var cords = Vector2i.ZERO

func _on_button_up():
	cell_clicked.emit(cords)
