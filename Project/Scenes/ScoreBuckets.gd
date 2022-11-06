extends Node2D

onready var scoreBuckets = get_tree().get_nodes_in_group("ScoreBucket")
var count = 0
var countTrueTarget = 3
var countTrueCurrent = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for bucket in scoreBuckets:
		if bucket.getStatus():
			countTrueCurrent += 1
			print("Count of good buckets: " + str(countTrueCurrent))

func _on_BucketTimer_timeout():
	#var i = 2
	#while
	
	for bucket in scoreBuckets:
		if bucket.getStatus() and countTrueCurrent > countTrueTarget:
			bucket.toggleStatus()
			print("Toggling bucket")
			countTrueCurrent-=1
