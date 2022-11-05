extends StaticBody2D

signal organism_scoreds

func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("organism"):
		emit_signal("organism_scored")
