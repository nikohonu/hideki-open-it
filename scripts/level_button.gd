@tool
extends VBoxContainer


signal pressed
enum Status {ACTIVE, LOCKED, COMPLETED}

@export var texture_active: CompressedTexture2D
@export var texture_locked: CompressedTexture2D:
	set(texture):
		texture_locked = texture
@export var texture_complete: CompressedTexture2D
@export var text: String = "Name":
	set(new_text):
		text = new_text
@export var status: Status = Status.ACTIVE:
	set(value):
		if value == Status.ACTIVE:
			$TextureButton.disabled = false
			$TextureButton.texture_normal = texture_active
		elif value == Status.LOCKED:
			$TextureButton.disabled = true
			$TextureButton.texture_disabled = texture_locked
		else:
			$TextureButton.disabled = false
			$TextureButton.texture_normal = texture_complete
		status = value

func _ready():
	$Label.set_text(text)

func _on_texture_button_pressed():
	pressed.emit()
