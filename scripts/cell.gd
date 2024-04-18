extends MeshInstance3D
class_name Cell

signal animation_finished

var texture_green_cell = preload("res://sprites/green_cell.png")
var texture_red_cell = preload("res://sprites/red_cell.png")
var texture_green_cell_face = preload("res://sprites/green_cell_face.png")
var texture_red_cell_face = preload("res://sprites/red_cell_face.png")


func set_state(cords, value, texture_backgroun, ratio):
	cords.y = 7 - cords.y
	if value < 0:
		mesh.get_material().set_shader_parameter("texture_front", texture_red_cell)
		mesh.get_material().set_shader_parameter("texture_face", texture_red_cell_face)
	elif value > 0:
		mesh.get_material().set_shader_parameter("texture_front", texture_green_cell)
		mesh.get_material().set_shader_parameter("texture_face", texture_green_cell_face)
	if value != 0:
		$Label3D.text = str(abs(value))
	mesh.get_material().set_shader_parameter("texture_background", texture_backgroun)
	mesh.get_material().set_shader_parameter("ratio", ratio)
	mesh.get_material().set_shader_parameter("cell", cords)


func select(fast = false):
	if fast:
		rotate_x(PI)
		return
	$AnimationPlayer.play("rotate")
	$Timer.start()	


func _on_timer_timeout():
	animation_finished.emit()
