extends Node2D

var lineNodes = [];
var polygon;
var polygon2;
var polygonPoints;
var polygonPoints2;
var isDragging = false;
var dragDuration = 0.1;
var prevMousePosition;
var segmentGap = false;
var segmentAlternate = false;

onready var magicSegmentInstace = preload("res://Scenes/MagicSegment.tscn");
onready var organism = preload("res://Scenes/Organism.tscn")
var currMagicSegment = null;
var prevMagicSegments = [];

export var DECAY_TIME = 0.1;

var length = 0;

func _ready():
	startDecay();

func _process(delta):
	if (isDragging and (get_global_mouse_position() - currMagicSegment.prevMousePosition).length() > 20):
		currMagicSegment.addLineSegment();
		currMagicSegment.prevMousePosition = get_global_mouse_position();

func _input(event):
	
	if Input.is_action_just_pressed("mouse_left"):
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
			isDragging = false;
			
	if Input.is_action_just_pressed(("mouse_right")):
		var new = organism.instance();
		new.position.x = 500
		add_child(new);
		
func startDecay():
	var timer = Timer.new();
	timer.one_shot = true;
	timer.wait_time = DECAY_TIME;
	timer.connect("timeout", self, "decay")
	add_child(timer)
	timer.start();
	
func decay():
	
	for segment in prevMagicSegments:
		if segment.length > 0:
			segment.removeLineSegment()
			break;
		if segment.length <= 0:
			prevMagicSegments.remove(0)
			break;
		
	startDecay();
