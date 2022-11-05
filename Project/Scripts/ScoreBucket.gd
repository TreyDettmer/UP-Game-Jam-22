extends StaticBody2D

signal organism_scored

func _ready():
	$ConfettiAnimation.hide()

func _process(_delta):
	if $ConfettiAnimation.frame >= 7 and $ConfettiAnimation.playing:
		$ConfettiAnimation.playing = false
		$ConfettiAnimation.frame = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("organism"):
		emit_signal("organism_scored")
		$ConfettiAnimation.show()
		$ConfettiAnimation.play("default")
		print($ConfettiAnimation.playing)
		print($ConfettiAnimation.frame)
