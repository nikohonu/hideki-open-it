extends MeshInstance3D

signal animation_finished

var green_cell_sprite = preload("res://sprites/green_cell.png")
var red_cell_sprite = preload("res://sprites/red_cell.png")
var green_cell_sprite_face = preload("res://sprites/green_cell_face.png")
var red_cell_sprite_face = preload("res://sprites/red_cell_face.png")

var cords:
	set(c):
		mesh.get_material().set_shader_parameter("cell", c)
		position = Global.cords_to_position(c)
		cords = c
var value: int:
	get:
		return value
	set(v):
		value = v
		if value < 0:
			mesh.get_material().set_shader_parameter("texture_front", red_cell_sprite)
			mesh.get_material().set_shader_parameter("texture_face", red_cell_sprite_face)
		elif value > 0:
			mesh.get_material().set_shader_parameter("texture_front", green_cell_sprite)
			mesh.get_material().set_shader_parameter("texture_face", green_cell_sprite_face)
		if value != 0:
			$Label3D.text = str(abs(v))


func select():
	$AnimationPlayer.play("rotate")


func _on_animation_player_animation_finished(_anim_name):
	emit_signal("animation_finished")
