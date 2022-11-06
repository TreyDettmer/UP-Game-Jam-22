extends StaticBody2D


signal organism_scored(goodBucket,organism)
export var goodBucket = true

var timeSinceFlip = 0

func _ready():
	$ConfettiAnimation.hide()

func _process(_delta):
	if goodBucket:
		$Leftcollisionrampbroken.hide()
		$Rightcollisionrampbroken.hide()
		$Leftcollisionramp.show()
		$Rightcollisionramp.show()
		$BucketNoLid.show()
	else:
		$Leftcollisionrampbroken.show()
		$Rightcollisionrampbroken.show()
		$Leftcollisionramp.hide()
		$Rightcollisionramp.hide()
		$BucketNoLid.hide()
	
	
	if $ConfettiAnimation.frame >= 7 and $ConfettiAnimation.playing:
		$ConfettiAnimation.playing = false
		$ConfettiAnimation.frame = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("organism"):
		emit_signal("organism_scored", goodBucket,body)
		if goodBucket:
			$ConfettiAnimation.show()
			$ConfettiAnimation.play("default")

func toggleStatus():
	goodBucket = !goodBucket
	
func getStatus():
	return goodBucket
	
func setStatus(status):
	goodBucket = status
