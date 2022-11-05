extends Node2D

signal updateScore(newScore)
signal updateOrganisms(numOrgs)
signal updateObstacles(numObs)

const SAVE_FILE_PATH = "user://savedata.save"

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
	load_highScore()
	
func _on_ScoreBucket_organism_scored():
	currentScore+=1
	emit_signal("updateScore", currentScore)
	print(currentScore)
	
func gameOver():
	#call the end screen
	
	if currentScore > highScore:
		highScore = currentScore
		save_highScore()

func save_highScore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(highScore)
	save_data.close()
	

func load_highScore():
	var save_data = File.new()
	#must check if it exists first
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		highScore = save_data.get_var() #reads first variable
		save_data.close()
