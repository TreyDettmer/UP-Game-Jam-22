extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$ClickSound.play();
	get_tree().change_scene("res://Scenes/Main.tscn");


func _on_HelpButton_pressed():
	pass # Replace with function body.
