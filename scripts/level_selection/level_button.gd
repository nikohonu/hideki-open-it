@tool
class_name LevelButton
extends VBoxContainer


signal pressed
signal focus_changed

enum Status { ACTIVE, LOCKED, COMPLETED }

@export var texture_button: TextureButton
@export var label: Label
@export var icon_label: Label

@export var text: String = "Name":
	set(new_text):
		text = new_text
		label.set_text(text)

@export var icon: String = "字":
	set(new_text):
		icon = new_text
		icon_label.set_text(icon)

@export var status: Status = Status.ACTIVE:
	set(value):
		if value == Status.ACTIVE:
			texture_button.disabled = false
			texture_button.texture_normal.region.position.x = 384 if has_save else 256
		elif value == Status.LOCKED:
			texture_button.disabled = true
		else:
			texture_button.disabled = false
			texture_button.texture_normal.region.position.x = 128 if has_save else 0
		status = value

@export var has_save: bool = false:
	set(value):
		has_save = value
		status = status

var focused = false


func focus():
	texture_button.grab_focus()


func unfocus():
	texture_button.release_focus()


func _on_texture_button_pressed():
	pressed.emit()


func _on_texture_button_focus_entered() -> void:
	focused = true
	icon_label.modulate = Color(0, 0, 0)
	focus_changed.emit()


func _on_texture_button_focus_exited() -> void:
	focused = false
	icon_label.modulate = Color(1, 1, 1)
