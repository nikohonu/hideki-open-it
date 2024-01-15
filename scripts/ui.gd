extends CenterContainer

var cell_ui_scene = preload("res://scenes/cell_ui.tscn")


func _ready():
	for i in range(%Map.size):
		for j in range(%Map.size):
			var cell_ui = cell_ui_scene.instantiate()
			cell_ui.connect("cell_clicked", %Cursor.on_mouse_click)
			cell_ui.cords = Vector2i(j, 7 - i)
			%GridContainer.add_child(cell_ui)
