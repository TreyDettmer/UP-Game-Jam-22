extends Control

onready var gameOverScore = get_node("GameOverMenu/Score")
#onready var gameOverHighScore = get_node("GameOverMenu/HighScoreEndGame")

var score
var highScore
signal endGame(score)
signal restartGame(score)

func _ready():
	$GameOverMenu.hide()
	$GameOverRect.hide()


func _on_Main_updateScore(newScore):
	$CurrentScoreLabel.set_text("Score: " + str(newScore))
	score = newScore


func _on_Main_updateOrganisms(numOrgs):
	$NumOrganisms.set_text("Active\nOrganisms: " + str(numOrgs))


func _on_Main_updateObstacles(numObs):
	$NumObstacles.set_text("Available\nObstacles: " + str(numObs))


func endGame():
	$GameOverMenu.show()
	#$GameOverRect.show()
	gameOverScore.set_text("Score: " + str(score))

func _on_QuitButton_pressed():
	emit_signal("endGame", score)


func _on_RestartButton_pressed():
	emit_signal("restartGame", score)


func _on_OptionsMenu_endGameFromMenu():
	_on_QuitButton_pressed()


func _on_Main_updateHighScore(prevHighScore):
	$HighScoreLabel.set_text("Prev Best: " + str(prevHighScore))
	highScore = prevHighScore

