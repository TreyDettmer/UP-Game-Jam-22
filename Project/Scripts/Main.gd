extends Node2D

export var currentScore = 0
var highScore = 0

export var initialOrganisms = 4
export var initialObstacles = 20
export var max_organism_count = 400;

onready var organism = preload("res://Scenes/Organism.tscn")
var orgs = [] #array for loading total organisms
# array of all organisms that could possibly be in the level
var organism_pool = [];
# current index in the pool of the next organism that will be created
var organism_current_pool_index = 0;
# array holding the times that each organism last reproduced
var orgs_reproduction_times = [];
var rng = RandomNumberGenerator.new();
var viewport_size = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize();
	viewport_size = get_viewport().size;
	create_organism_pool();
	spawn_organisms();

func create_organism_pool():
	print("Creating organism pool...");
	for i in range(max_organism_count):
		var instantiated_organism = organism.instance();
		disable_organism(instantiated_organism);
		instantiated_organism.connect("organism_reproduced",self,"handle_organism_reproduction");
		organism_pool.push_back(instantiated_organism);
		add_child(instantiated_organism);
	print("Finished creating organism pool");

func spawn_organisms():
	var spawn_point = Vector2.ZERO;
	
	for i in range(initialOrganisms):
		spawn_point = Vector2(rng.randf_range(30.0,viewport_size.x - 30.0), 0.0);
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
	spawn_point = Vector2(rng.randf_range(30.0,viewport_size.x - 30.0), 0.0);

	parent_organism1.reset_position = spawn_point;
	parent_organism1.should_reset = true;
	parent_organism1.separate_from_all();
	
	# reposition parent 2
	spawn_point = Vector2(rng.randf_range(30.0,viewport_size.x - 30.0), 0.0);

	parent_organism2.reset_position = spawn_point;
	parent_organism2.should_reset = true;
	parent_organism2.separate_from_all();
	
	if organism_current_pool_index >= max_organism_count:
		print("Reached max organism count");
		return;

	# spawn child
	spawn_point = Vector2(rng.randf_range(30.0,viewport_size.x - 30.0), 0.0);
	var instantiated_organism = organism_pool[organism_current_pool_index];
	orgs.push_back(instantiated_organism);
	orgs_reproduction_times.push_back(OS.get_ticks_msec());
	instantiated_organism.set_position(spawn_point);
	enable_organism(instantiated_organism);
	organism_current_pool_index += 1;
	print("Organism count: " + String(organism_current_pool_index));


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
