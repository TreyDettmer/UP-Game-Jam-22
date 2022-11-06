extends StaticBody2D

signal organism_scored(goodBucket)
export var goodBucket = true

var timeSinceFlip = 0

func _ready():
	$ConfettiAnimation.hide()

func _process(_delta):
	if goodBucket:
		$leftside.modulate = Color(0,1,0)
		$rightside.modulate = Color(0,1,0)
	else:
		$leftside.modulate = Color(1,0,0)
		$rightside.modulate = Color(1,0,0)
	
	
	if $ConfettiAnimation.frame >= 7 and $ConfettiAnimation.playing:
		$ConfettiAnimation.playing = false
		$ConfettiAnimation.frame = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("organism"):
		emit_signal("organism_scored", goodBucket)
		if goodBucket:
			$ConfettiAnimation.show()
			$ConfettiAnimation.play("default")

func toggleStatus():
	goodBucket = !goodBucket
	
func getStatus():
	return goodBucket
	
func setStatus(status):
	goodBucket = status
