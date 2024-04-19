@tool
class_name LevelButton
extends VBoxContainer

signal pressed

enum Status { ACTIVE, LOCKED, COMPLETED }

@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $Label
@onready var icon_label: Label = $TextureButton/Label

@export var text: String = "Name":
	set(new_text):
		text = new_text
		label.set_text(text)
@export var icon_text: String = "字":
	set(new_text):
		icon_text = new_text
		icon_label.set_text(icon_text)
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
		print(value)
		has_save = value
		status = status


func _ready():
	label.set_text(text)


func _on_texture_button_pressed():
	pressed.emit()
