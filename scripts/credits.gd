extends Control


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	RenderingServer.set_default_clear_color(Color("4d4d4d"))
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
