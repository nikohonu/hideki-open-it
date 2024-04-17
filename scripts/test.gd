extends Control


func _input(event):
	if event.is_action_pressed("test"):
		visible = !visible


func _on_reset_progress_pressed():
	Global.progress = [
		Global.Status.ACTIVE,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
		Global.Status.LOCKED,
	]
	Global.save_progress()


func _on_reset_state_pressed():
	Global.reset_save()

