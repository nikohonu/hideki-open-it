extends CenterContainer

@onready var game: Game = get_tree().get_current_scene()


func end():
	var tween = create_tween()
	tween.tween_method(change_visibility.bind(%LabelResult), 0.0, 1.0, 3).set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(after_label)


func after_label():
	var tween = create_tween()
	tween.tween_method(change_visibility.bind(%Fade), 0.0, 1.0, 3).set_trans(Tween.TRANS_LINEAR)
	Global.game_stats[game.level-1] = min(Global.game_stats[game.level-1] + 1, 2) 
	tween.finished.connect(Global.change_scene.bind("res://scenes/levels.tscn"))


func change_visibility(alpha: float, node: Control):
	node.modulate = Color(1, 1, 1, alpha)
