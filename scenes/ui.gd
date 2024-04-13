extends Control
class_name UI

func set_turn(turn):
	$VBoxContainer/Turn.set_text("Turn: Player %s" % (turn + 1))

func set_scores(scores: Array):
	$VBoxContainer/Player1Score.set_text("Player 1 Score: %s" % scores[0])
	$VBoxContainer/Player2Score.set_text("Player 2 Score: %s" % scores[1])


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
