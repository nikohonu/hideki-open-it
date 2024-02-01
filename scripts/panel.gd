extends TextureRect
class_name PanelUI

@export_range(0.1, 2, 0.1) var speed

@onready var scores_labels = [%P1Score, %P2Score]

var tweens = [null, null]
var scores = [0, 0]

func _set_score(score, player):
	scores_labels[player].text = "%03d" % score if score >= 0 else "-%03d" % abs(score)
	scores[player] = score

func add_score(player: Game.Player,  score: int):
	var diff = abs(scores[player] - score)
	if tweens[player]:
		tweens[player].kill()
	tweens[player] = create_tween()
	var s = scores[player]
	var d = (0.1/speed) * diff
	tweens[player].tween_method(_set_score.bind(player), s, score, d).set_trans(Tween.TRANS_LINEAR)

func set_turn(turn: Game.Player):
	var is_first = turn == Game.Player.FIRST
	$P1StatusBackground.frame = 0 if is_first else 1
	$P2StatusBackground.frame = 1 if is_first else 0
	$P1Status.text = "Move" if is_first else "Stay"
	$P2Status.text = "Stay" if is_first else "Move"
