extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Main_updateScore(newScore):
	$CurrentScoreLabel.set_text("Score: " + str(newScore))


func _on_Main_updateOrganisms(numOrgs):
	$NumOrganisms.set_text("Active\nOrganisms: " + str(numOrgs))


func _on_Main_updateObstacles(numObs):
	$NumObstacles.set_text("Available\nObstacles: " + str(numObs))
