extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mute"):
		var master_sound = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(master_sound, !AudioServer.is_bus_mute(master_sound))


func _on_StartButton_pressed():
	$ClickSound.play();
	get_tree().change_scene("res://Scenes/Main.tscn");


func _on_HelpButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit();
