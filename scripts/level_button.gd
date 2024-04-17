@tool
extends Control

signal pressed
enum Status { ACTIVE, LOCKED, COMPLETED }

@export var texture_button: TextureButton
@export var label: Label
@export var texture_active: CompressedTexture2D
@export var texture_locked: CompressedTexture2D:
	set(texture):
		texture_locked = texture
@export var texture_complete: CompressedTexture2D
@export var text: String = "Name":
	set(new_text):
		text = new_text
		label.set_text(text)
@export var status: Status = Status.ACTIVE:
	set(value):
		if value == Status.ACTIVE:
			texture_button.disabled = false
			texture_button.texture_normal = texture_active
		elif value == Status.LOCKED:
			texture_button.disabled = true
			texture_button.texture_disabled = texture_locked
		else:
			texture_button.disabled = false
			texture_button.texture_normal = texture_complete
		status = value
@export var has_save: bool = false:
	set(value):
		$TextureRect.visible = value
		has_save = value


func _ready():
	label.set_text(text)


func _on_texture_button_pressed():
	pressed.emit()
