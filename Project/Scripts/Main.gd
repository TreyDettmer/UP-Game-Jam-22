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
export var max_organism_count = 400;
export var endGame_populationLimit = 50 #The maximum population before the game ends
export var max_organism_age = 5;
export var min_obstacle_y_value = 300;
var isGameOver = false

onready var organism = preload("res://Scenes/Organism.tscn")
var orgs = [] #array for loading total organisms

onready var menuLayer = get_node("UI")
# array of all organisms that could possibly be in the level
var organism_pool = [];
# current index in the pool of the next organism that will be created
var organism_current_pool_index = 0;
# array holding the times that each organism last reproduced
var orgs_reproduction_times = [];
var rng = RandomNumberGenerator.new();
var viewport_size = Vector2.ZERO;
var max_x_position = 1000.0;
var min_x_position = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize();
	emit_signal("updateScore", currentScore)
	emit_signal("updateObstacles", $ObstaclePile.quantity)
	emit_signal("updateOrganisms", initialOrganisms)
	
	load_highScore()
	viewport_size = get_viewport().size;
	min_x_position = 200;
	max_x_position = viewport_size.x - 200;
	create_organism_pool();
	spawn_organisms();

func _process(_delta):
	#$BucketTimer.time_left
	$PatternSwitchTimer.set_text(str($BucketTimer.time_left))
	
	if  orgs.size() > endGame_populationLimit:
		isGameOver = true
		gameOver()
	
	if Input.is_action_just_pressed("mute"):
		var master_sound = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(master_sound, !AudioServer.is_bus_mute(master_sound))
func create_organism_pool():
	print("Creating organism pool...");
	for i in range(max_organism_count):
		var instantiated_organism = organism.instance();
		instantiated_organism.min_x_position = min_x_position;
		instantiated_organism.max_x_position = max_x_position;
		instantiated_organism.max_age = max_organism_age;
		disable_organism(instantiated_organism);
		instantiated_organism.connect("organism_reproduced",self,"handle_organism_reproduction");
		instantiated_organism.connect("organism_died",self,"handle_organism_death");
		organism_pool.push_back(instantiated_organism);
		add_child(instantiated_organism);
	print("Finished creating organism pool");

func spawn_organisms():
	if isGameOver:
		pass
	
	var spawn_point = Vector2.ZERO;
	
	for _i in range(initialOrganisms):
		spawn_point = Vector2(rng.randf_range(min_x_position,max_x_position), 0.0);
		var instantiated_organism = organism_pool[organism_current_pool_index];
		orgs.push_back(instantiated_organism);
		orgs_reproduction_times.push_back(OS.get_ticks_msec());
		instantiated_organism.set_position(spawn_point);
		enable_organism(instantiated_organism);
		organism_current_pool_index += 1;

# called when organisms reproduce
func spawn_organism_family(parent_organism1,parent_organism2):
	var spawn_point = Vector2.ZERO;
	
	# reposition parent 1
	spawn_point = Vector2(rng.randf_range(min_x_position,max_x_position), 0.0);

	parent_organism1.reset_position = spawn_point;
	parent_organism1.should_reset = true;
	parent_organism1.separate_from_all();
	
	# reposition parent 2
	spawn_point = Vector2(rng.randf_range(min_x_position,max_x_position), 0.0);

	parent_organism2.reset_position = spawn_point;
	parent_organism2.should_reset = true;
	parent_organism2.separate_from_all();
	
	if organism_current_pool_index >= max_organism_count:
		print("Reached max organism count");
		return;

	# spawn child
	spawn_point = Vector2(rng.randf_range(min_x_position,max_x_position), 0.0);
	var instantiated_organism = organism_pool[organism_current_pool_index];
	orgs.push_back(instantiated_organism);
	orgs_reproduction_times.push_back(OS.get_ticks_msec());
	instantiated_organism.set_position(spawn_point);
	enable_organism(instantiated_organism);
	emit_signal("updateOrganisms", orgs.size());
	organism_current_pool_index += 1;


func handle_organism_reproduction(organism1, organism2):
	var organism1_index = orgs.find(organism1);
	var organism2_index = orgs.find(organism2);
	
	# ensure organisms didn't just reproduce
	if OS.get_ticks_msec() - orgs_reproduction_times[organism1_index] > 1000 and OS.get_ticks_msec() - orgs_reproduction_times[organism2_index] > 1000:
		orgs_reproduction_times[organism1_index] = OS.get_ticks_msec();
		orgs_reproduction_times[organism2_index] = OS.get_ticks_msec();
		spawn_organism_family(organism1,organism2);
	
func enable_organism(org):
	org.visible = true;
	org.set_process(true);
	org.set_physics_process(true);
	org.get_node("CollisionShape2D").disabled = false;
	org.set_mode(0);
	
func disable_organism(org):
	org.visible = false;
	org.set_process(false);
	org.set_physics_process(false);
	org.get_node("CollisionShape2D").disabled = true;
	org.set_mode(1);

	

func _on_ScoreBucket_organism_scored(goodBucket,org):
	if goodBucket:
		currentScore+=1
	org.Age();
	emit_signal("updateScore", currentScore)
	print(currentScore)
	
func handle_organism_death(org):
	var organism_index = orgs.find(org);
	orgs.remove(organism_index);
	orgs_reproduction_times.remove(organism_index);
	emit_signal("updateOrganisms", orgs.size());
	if orgs.size() <= 0:
		isGameOver = true
		gameOver()


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
	get_tree().paused = false;
	get_tree().change_scene("res://Scenes/MainMenu.tscn");
	

func _on_MenuLayer_restartGame(score):
	calcScore(score)
	get_tree().reload_current_scene()

func gameOver():
	#pulls up the endGame menu
	menuLayer.endGame()
	#stops the other organisms
	get_tree().call_group("organism", "set_physics_process", false)
	killOrgs()
	killObjs()
	$MusicPlayer.stop();
	$GameOverSound.play();
	
func killOrgs():
	var orgsdelete = get_tree().get_nodes_in_group("organism")
	for org in orgsdelete:
		disable_organism(org)
		org.queue_free()
	
func killObjs():
	var objsdelete = get_tree().get_nodes_in_group("objects")
	for obj in objsdelete:
		obj.queue_free()


func _on_ObstaclePile_quantity_changed(newAmount):
		emit_signal("updateObstacles", newAmount)
