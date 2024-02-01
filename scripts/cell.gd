extends MeshInstance3D

signal animation_finished

var texture_green_cell = preload("res://sprites/green_cell.png")
var texture_red_cell = preload("res://sprites/red_cell.png")
var texture_green_cell_face = preload("res://sprites/green_cell_face.png")
var texture_red_cell_face = preload("res://sprites/red_cell_face.png")


func set_state(cords, value, texture_backgroun, ratio):
	position = Global.cords_to_position(cords)
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


func select():
	$AnimationPlayer.play("rotate")


func _on_animation_player_animation_finished(_anim_name):
	emit_signal("animation_finished")
