extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	RenderingServer.set_default_clear_color(Color("4d4d4d"))
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
