extends Node2D

# ObstaclePile
# Defines a generator for obstacles. Whenever an obstacle is dragged off the
# top of the pile, a new one is created.

signal quantity_changed(newAmount)

# Number of obstacles in this pile
export var quantity = 5;

onready var topOfPile = get_node("Obstacle");
const OBSTACLE = preload("res://Scenes/Obstacle.tscn");

func _ready():
	topOfPile.connect("dragged", self, "onDragObstacle");

# Called by the obstacle at the top of the pile when it has been dragged
func onDragObstacle():
	
	# A new obstacle has been dragged off the pile, so we generate a new one
	if (quantity > 0):
		topOfPile.disconnect("dragged", self, "onDragObstacle")
		topOfPile = generateObstacle();
		quantity -= 1;
		emit_signal("quantity_changed", quantity);
		
# Generates a new obstacle and connects its signals
func generateObstacle():
	var newObstacle = OBSTACLE.instance();
	self.add_child(newObstacle);
	
	newObstacle.position = Vector2.ZERO;
	newObstacle.connect("dragged", self, "onDragObstacle");
	
	return newObstacle;
	
