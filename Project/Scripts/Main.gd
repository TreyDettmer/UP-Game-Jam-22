extends Node2D

signal updateScore(newScore)
signal updateOrganisms(numOrgs)
signal updateObstacles(numObs)

export var currentScore = 0
var highScore = 0

export var initialOrganisms = 4
export var initialObstacles = 20

onready var organism = preload("res://Scenes/Organism.tscn")
var orgs = [] #array for loading total organisms


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("updateScore", currentScore)
	emit_signal("updateObstacles", initialObstacles)
	emit_signal("updateOrganisms", initialOrganisms)
	
func _on_ScoreBucket_organism_scored():
	currentScore+=1
	emit_signal("updateScore", currentScore)
	print(currentScore)
