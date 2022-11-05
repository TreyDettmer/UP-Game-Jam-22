extends Node2D

export var currentScore = 0
var highScore = 0

export var initialOrganisms = 4
export var initialObstacles = 20

onready var organism = preload("res://Scenes/Organism.tscn")
var orgs = [] #array for loading total organisms


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
