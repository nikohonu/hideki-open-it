extends Node2D

var cell = preload("res://scenes/cell.tscn")
var cell_size = Vector2(96, 96)
var map_size = Vector2i(8, 8)
var center = Vector2.ZERO

var used_value = {}


func get_cell_value():
	while true:
		var value = randi_range(-11, 11)
		if value == 0:
			continue
		if value not in used_value:
			used_value[value] = 0
		if used_value[value] < 3:
			used_value[value] += 1
			return value


func _ready():
	var size = get_viewport().get_visible_rect().size
	var center = Vector2(size.x / 2 - 128, size.y / 2)
	var start = Vector2(
		center.x - cell_size.x * (map_size.x / 2), center.y - cell_size.y * (map_size.y / 2)
	)
	for i in range(map_size.y):
		for j in range(map_size.x):
			var local_cell: Node2D = cell.instantiate()
			local_cell.position = Vector2(start.x + (cell_size.x * j), start.y + (cell_size.y * i))
			local_cell.cords = Vector2i(j, i)
			local_cell.value = get_cell_value()
			add_child(local_cell)
	print(center)


func _process(delta):
	pass
