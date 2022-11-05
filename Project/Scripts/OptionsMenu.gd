extends Control


var gamePaused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuBackground.hide()
	

func _on_QuitButton_pressed():
	get_tree().quit()


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
