@tool
extends MeshInstance3D

@export_range(-11, 11) var value = 11:
	set(new_value):
		value = new_value
		$Label3D.text = str(value)


func _ready():
	pass


func _process(delta):
	pass
