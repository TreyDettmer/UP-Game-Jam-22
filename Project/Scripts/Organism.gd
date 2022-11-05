extends RigidBody2D
signal organism_reproduced(organism,partner);

# how long until two touching organisms reproduce
export var reproduction_delay = 2.0;

# array of organisms i am touching
var organisms_i_am_touching = [];
# array of the timestamp of when I first touched each other organism
var organisms_i_am_touching_times = [];

var should_reset = false;
var reset_position = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_if_should_reproduce(delta);



func check_if_should_reproduce(_delta):
	
		var array_size = organisms_i_am_touching.size();
		var organism_index =  organisms_i_am_touching.size() - 1;
		while organism_index >= 0:
			if organisms_i_am_touching.size() != 0: 
				if organisms_i_am_touching[organism_index] == null or not is_instance_valid(organisms_i_am_touching[organism_index]):
					organisms_i_am_touching.remove(organism_index);
					organisms_i_am_touching_times.remove(organism_index);
					organism_index -= 1;
					continue;
				if OS.get_ticks_msec() - organisms_i_am_touching_times[organism_index] >= reproduction_delay * 1000.0:
					organisms_i_am_touching_times[organism_index] = OS.get_ticks_msec();
					emit_signal("organism_reproduced",self,organisms_i_am_touching[organism_index]);
			organism_index -= 1;


func _on_Organism_body_entered(body):
	if body.is_in_group("organism"):
		attach_to(body);
			

func _on_Organism_body_exited(body):
	if body.is_in_group("organism"):
		separate_from(body);
		
# attaches another organism to self
func attach_to(attached_organism):
	# ensure we are not already attached to this organism
	if organisms_i_am_touching.find(attached_organism) == -1:
		organisms_i_am_touching.push_back(attached_organism);
		organisms_i_am_touching_times.push_back(OS.get_ticks_msec());

		
# separates self from another organism
func separate_from(separated_organism):
	var organism_index = organisms_i_am_touching.find(separated_organism);
	if organism_index >= 0:
		organisms_i_am_touching.remove(organism_index);
		organisms_i_am_touching_times.remove(organism_index);

# separates self from all attached organisms		
func separate_from_all():
	var organism_index =  organisms_i_am_touching.size() - 1;
	while organism_index >= 0:
		organisms_i_am_touching.remove(organism_index);
		organisms_i_am_touching_times.remove(organism_index);
		organism_index -= 1;
	
func _integrate_forces(state):
	if should_reset:	
		var form = state.get_transform().rotated(-state.get_transform().get_rotation());
		
		form.origin.x = reset_position.x;
		form.origin.y = reset_position.y;
		state.set_transform(form);
		should_reset = false
