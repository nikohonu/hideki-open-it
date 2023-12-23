extends Node2D

var cords = Vector2i.ZERO
var value: int:
	get:
		return value
	set(i):
		value = i
		if value < 0:
			$TextureButton.self_modulate = Color.RED
		else:
			$TextureButton.self_modulate = Color.GREEN
		$TextureButton/Label.text = label_dict[abs(i)]

var label_dict = {
	1: "0",
	2: "1",
	3: "2",
	4: "3",
	5: "4",
	6: "5",
	7: "6",
	8: "7",
	9: "8",
	10: "9",
	11: "a",
}


func _ready():
	pass


func _process(delta):
	pass


func _on_texture_button_pressed():
	print(cords)
