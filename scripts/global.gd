extends Node


func cords_to_position(cords: Vector2, z = 0.0):
	return Vector3(cords.x - 4 + 0.5 - (4 / 3.), cords.y - 4 + 0.5, z)
