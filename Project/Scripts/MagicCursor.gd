extends Node2D

var lineNodes = [];
var polygon;
var polygon2;
var polygonPoints;
var polygonPoints2;
var isDragging = false;
var disableDrawing = false;
var dragDuration = 0.1;
var prevMousePosition;
var segmentGap = false;
var segmentAlternate = false;

onready var magicSegmentInstace = preload("res://Scenes/MagicSegment.tscn");
var currMagicSegment = null;
var prevMagicSegments = [];

export var DECAY_TIME = 0.1;

var length = 0;

func _ready():
	startDecay();

func _process(delta):
	if (disableDrawing):
		return
	if (!isCursorWithinBounds()):
		if (isDragging):
			isDragging = false;
			prevMagicSegments.append(currMagicSegment);
			currMagicSegment = null;
		return;
	if (isDragging and (get_global_mouse_position() - currMagicSegment.prevMousePosition).length() > 20):
		currMagicSegment.addLineSegment();
		currMagicSegment.prevMousePosition = get_global_mouse_position();

func _input(event):
	
	if Input.is_action_just_pressed("mouse_left"):
		# Check if ObstaclePile is using left mouse input, so we don't drag
		# a line while dragging an obstacle
		if (disableDrawing or !isCursorWithinBounds()):
			return
	
		if (!isDragging):
			if (currMagicSegment != null):
				prevMagicSegments.append(currMagicSegment);
			
			currMagicSegment = magicSegmentInstace.instance();
			add_child(currMagicSegment);
			
			currMagicSegment.addLineSegment();
			currMagicSegment.prevMousePosition = get_global_mouse_position();
			isDragging = true;
	if Input.is_action_just_released("mouse_left"):
		if (isDragging):
			prevMagicSegments.append(currMagicSegment);
			currMagicSegment = null;
			isDragging = false;
			
		
func startDecay():
	var timer = Timer.new();
	timer.one_shot = true;
	timer.wait_time = DECAY_TIME;
	timer.connect("timeout", self, "decay")
	add_child(timer)
	timer.start();
	
func decay():
	
	for segment in prevMagicSegments:
		if segment == null:
			break;
		if segment.length > 0:
			segment.removeLineSegment()
			break;
		if segment.length <= 0:
			prevMagicSegments.remove(0)
			break;
		
	startDecay();
	
func isCursorWithinBounds():
	if (get_parent() != null):
		if (get_parent().min_obstacle_y_value < get_global_mouse_position().y):
			return false;
	return true;
func onDragObstacle():
	disableDrawing = true;
	
func onReleaseObstacle():
	disableDrawing = false;
