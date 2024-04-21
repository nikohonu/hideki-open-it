class_name Cell
extends MeshInstance3D


signal animation_finished

@export var label: Label3D
@export var timer: Timer
@export var animation_player: AnimationPlayer

var material: Material
var texture_green = preload("res://sprites/game/green_cell.png")
var texture_green_active = preload("res://sprites/game/green_cell_active.png")
var texture_green_face = preload("res://sprites/game/green_cell_face.png")
var texture_red = preload("res://sprites/game/red_cell.png")
var texture_red_active = preload("res://sprites/game/red_cell_active.png")
var temture_red_face = preload("res://sprites/game/red_cell_face.png")

var selected = false
var value: int:
	set(_value):
		value = _value
		if value < 0:
			_set_shader_parameter("texture_front", texture_red)
			_set_shader_parameter("texture_face", temture_red_face)
		elif value > 0:
			_set_shader_parameter("texture_front", texture_green)
			_set_shader_parameter("texture_face", texture_green_face)
		if value != 0:
			label.text = str(abs(value))

var active: bool:
	set(_active):
		active = _active
		if active:
			if value > 0:
				_set_shader_parameter("texture_front", texture_green_active)
			else:
				_set_shader_parameter("texture_front", texture_red_active)
		else:
			if value > 0:
				_set_shader_parameter("texture_front", texture_green)
			else:
				_set_shader_parameter("texture_front", texture_red)


func setup(coords, setup_value, texture_backgroun, ratio):
	material = mesh.get_material()
	position = Global.coordinates_2d_to_3d(coords)
	value = setup_value
	coords.y = 7 - coords.y
	_set_shader_parameter("texture_background", texture_backgroun)
	_set_shader_parameter("ratio", ratio)
	_set_shader_parameter("coords", coords)


func select(fast: bool = false):
	selected = true
	if fast:
		rotate_x(PI)
		return
	animation_player.play("rotate")
	timer.start()


func _set_shader_parameter(param: String, parameter_value: Variant):
	material.set_shader_parameter(param, parameter_value)


func _on_timer_timeout():
	animation_finished.emit()
