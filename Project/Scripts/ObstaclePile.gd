extends Node2D

# ObstaclePile
# Defines a generator for obstacles. Whenever an obstacle is dragged off the
# top of the pile, a new one is created.

signal quantity_changed(newAmount)

# Number of obstacles in this pile
export var quantity = 5;

onready var topOfPile = get_node("Obstacle");
onready var magicCursor = get_parent().get_node("MagicCursor");
const OBSTACLE = preload("res://Scenes/Obstacle.tscn");

func _ready():
	topOfPile.min_y_value = get_parent().min_obstacle_y_value - topOfPile.global_position.y;
	topOfPile.connect("dragged", self, "onDragObstacle");
	topOfPile.connect("dragged", magicCursor, "onDragObstacle");
	topOfPile.connect("released", magicCursor, "onReleaseObstacle");

# Called by the obstacle at the top of the pile when it has been dragged
func onDragObstacle():
	
	print("Dragged")
	# A new obstacle has been dragged off the pile, so we generate a new one
	if (quantity > 1):
		topOfPile.disconnect("dragged", self, "onDragObstacle")
		topOfPile = generateObstacle();
	if (quantity > 0):
		quantity -= 1;
		emit_signal("quantity_changed", quantity);
		
# Generates a new obstacle and connects its signals
func generateObstacle():
	var newObstacle = OBSTACLE.instance();
	
	self.add_child(newObstacle);
	newObstacle.min_y_value = get_parent().min_obstacle_y_value - newObstacle.global_position.y;
	newObstacle.position = Vector2.ZERO;
	newObstacle.connect("dragged", self, "onDragObstacle");
	newObstacle.connect("dragged", magicCursor, "onDragObstacle");
	newObstacle.connect("released", magicCursor, "onReleaseObstacle");
	
	return newObstacle;
	
