extends Node2D

onready var scoreBuckets = get_tree().get_nodes_in_group("ScoreBucket")
var count = 0
var countTrueTarget = 3
var countTrueCurrent = 0
var patternIndex = 0
var maxPatterns = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	for bucket in scoreBuckets:
		if bucket.getStatus():
			countTrueCurrent += 1
			print("Count of good buckets: " + str(countTrueCurrent))

func _on_BucketTimer_timeout():
	patternIndex+=1
	if patternIndex > maxPatterns:
		patternIndex = 0
	
	match patternIndex:
		0:
			patternDefault()
		1:
			patternFlip()
		2:
			patternEveryOther()
		3:
			patternIsland()
		4:
			patternPirate()
		5:
			patternInverseEveryOther()
		6:
			patternDefault()
			patternFlip()
	

func patternFlip():
	for bucket in scoreBuckets:
		bucket.toggleStatus()

func patternEveryOther():
	var i = 0
	for bucket in scoreBuckets:
		if i % 2:
			bucket.setStatus(true)
		else:
			bucket.setStatus(false)
		i+=1

func patternDefault():
	var i = 0
	while i < scoreBuckets.size():
		if i == 2 or i == 5 or i == 8:
			scoreBuckets[i].setStatus(true)
		else:
			scoreBuckets[i].setStatus(false)
		i+=1


func patternInverseEveryOther():
	var i = 1
	for bucket in scoreBuckets:
		if i % 2:
			bucket.setStatus(true)
		else:
			bucket.setStatus(false)
		i+=1

func patternPirate():
	var i = 0
	while i < scoreBuckets.size():
		if i == 1 or i == 2 or i == 6 or i == 7:
			scoreBuckets[i].setStatus(true)
		else:
			scoreBuckets[i].setStatus(false)
		i+=1

func patternIsland():
	var i = 0
	while i < scoreBuckets.size():
		if i == scoreBuckets.size()/2:
			scoreBuckets[i].setStatus(true)
		else:
			scoreBuckets[i].setStatus(false)
		i+=1
