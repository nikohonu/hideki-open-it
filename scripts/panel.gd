extends Sprite2D

var current_score = [0, 0]
var tweens = [null, null]
var scores_labels
var speed = 0.1

func update_score(player: Global.Player, score: int):
	var diff = abs(current_score[player] - score)
	if tweens[player]:
		tweens[player].kill()
	tweens[player] = create_tween()
	tweens[player].tween_method(_set_score.bind(player), current_score[player], score, speed * diff).set_trans(
		Tween.TRANS_LINEAR
	)


func _set_score(score, player: Global.Player,):
	scores_labels[player].text = "%03d" % score
	current_score[player] = score

func update_move_status(player: Global.Player):
	var is_fist = player == Global.Player.FIRST
	$P1StatusBackground.frame = 0 if is_fist else 1
	$P2StatusBackground.frame = 1 if is_fist else 0
	$P1Status.text = "Move" if is_fist else "Stay"
	$P2Status.text = "Stay" if is_fist else "Move"

func _ready():
	scores_labels = [$P1Score, $P2Score]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
