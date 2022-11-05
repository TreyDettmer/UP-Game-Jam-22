extends RigidBody2D
signal organism_reproduced(organism,partner);

# how long until two touching organisms reproduce
export var reproduction_delay = 2.0;

var touched_organism = null;
var is_touching_other_organism = false;
var last_time_organism_touched = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_should_reproduce(delta);


func check_if_should_reproduce(_delta):
	if is_touching_other_organism and is_instance_valid(touched_organism):
		# mutliply reproduction_delay by 1000 to convert milliseconds to seconds
		if OS.get_ticks_msec() - last_time_organism_touched >= reproduction_delay * 1000.0:
			last_time_organism_touched = OS.get_ticks_msec();
			print("Organism reproduced!");
			emit_signal("organism_reproduced",self,touched_organism);
			
	else:
		# we are no longer touching another organism
		touched_organism = null;
		is_touching_other_organism = false;

func _on_Organism_body_entered(body):
	if body.is_in_group("organism"):
		if not is_touching_other_organism:
			touched_organism = body;
			is_touching_other_organism = true;
			last_time_organism_touched = OS.get_ticks_msec();
			

func _on_Organism_body_exited(body):
	if body.is_in_group("organism"):
		touched_organism = null;
		is_touching_other_organism = false;
		
