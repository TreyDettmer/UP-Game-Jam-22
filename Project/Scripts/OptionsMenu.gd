extends Control


var gamePaused = false

signal endGameFromMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuBackground.hide()
	pass
	

func _on_QuitButton_pressed():
	emit_signal("endGameFromMenu")


func _on_ResumeButton_pressed():
	get_tree().paused = false
	gamePaused = false
	$MenuBackground.hide()
	$MenuButton.show()


func _on_MenuButton_pressed():
	get_tree().paused = true
	gamePaused = true
	$MenuButton.hide()
	$MenuBackground.show()
