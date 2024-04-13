extends GridContainer
class_name MapUI

signal cell_clicked(cords: Vector2i)

@export var cell_screne: PackedScene


func add_cell(cords):
	var cell: CellUI = cell_screne.instantiate()
	cell.cords = cords
	cell.clicked.connect(on_cell_click)
	add_child(cell)


func on_cell_click(cords):
	cell_clicked.emit(cords)
