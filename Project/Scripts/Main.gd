extends Node2D

signal updateScore(newScore)
signal updateHighScore(prevHighScore)
signal updateOrganisms(numOrgs)
signal updateObstacles(numObs)

const SAVE_FILE_PATH = "user://savedata.save"

export var currentScore = 0
var highScore = 0

export var initialOrganisms = 4
export var initialObstacles = 20

onready var organism = preload("res://Scenes/Organism.tscn")
var orgs = [] #array for loading total organisms

onready var MenuLayer = get_node("MenuLayer")

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


func calcScore(score):
	if currentScore > highScore:
		highScore = currentScore
		print("New high score: " + str(highScore))
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
		emit_signal("updateHighScore", highScore)
		print("Loaded high score: " + str(highScore))
		save_data.close()
		

#save the score and then quit
func _on_MenuLayer_endGame(score):
	calcScore(score)
	get_tree().quit()

func _on_MenuLayer_restartGame(score):
	calcScore(score)
	#go to the main menu
	#get_tree().change_scene(res://Scenes/MainMenu)

func gameOver():
	#pulls up the endGame menu
	MenuLayer.endGame()
	#stops the other organisms
	get_tree().call_group("organism", "set_physics_process", false)
	killOrgs()
	killObjs()
	
func killOrgs():
	var orgsdelete = get_tree().get_nodes_in_group("organisms")
	for org in orgsdelete:
		org.queue_free()
	
func killObjs():
	var objsdelete = get_tree().get_nodes_in_group("objects")
	for obj in objsdelete:
		obj.queue_free()
