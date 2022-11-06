extends Node2D

var lineNodes = [];
var polygon;
var polygon2;
var polygonPoints;
var polygonPoints2;
var enabled = true; # Whether or not this segment is active
var dragDuration = 0.1;
var prevMousePosition;
var segmentGap = false;
var segmentAlternate = false;

var isDecaying = false;

export var MAX_LENGTH = 20;
var length = 0;
onready var organism = preload("res://Scenes/Organism.tscn")

func _ready():
	polygon = ConcavePolygonShape2D.new()
	polygon2 = ConcavePolygonShape2D.new()
	polygonPoints = PoolVector2Array();
	polygonPoints2 = PoolVector2Array();
	prevMousePosition = get_global_mouse_position();

func removeLineSegment():
	
	if (length > 0):
		length -= 1
		
	lineNodes.remove(0)
	polygonPoints.remove(0)
	polygonPoints2.remove(0)
	
	polygon.segments = polygonPoints;
	$LineSegment1/CollisionShape2D.shape = polygon;
		
	polygon2.segments = polygonPoints2;
	$LineSegment2/CollisionShape2D.shape = polygon2;
	
	isDecaying = true;
	
	update()
	

func addLineSegment():
	
		if (length >= MAX_LENGTH):
			return;
		
		length += 1
		
		lineNodes.append(get_global_mouse_position())
		polygonPoints.append(get_global_mouse_position())
		polygon.segments = polygonPoints;
		$LineSegment1/CollisionShape2D.shape = polygon;
		
		if (segmentGap):
			polygonPoints2.append(get_global_mouse_position());
			polygon2.segments = polygonPoints2;
			$LineSegment2/CollisionShape2D.shape = polygon2;
		if (!segmentGap):
			segmentGap = true;
		
		update()
func _draw():
	
	var color = Color.white;
	for i in range(0, lineNodes.size()-1):
		
		if (isDecaying):
			var coefficient = 1.0/lineNodes.size();
			color.a = 2.0 - (abs(lineNodes.size() - i) * coefficient + 0.5);
		else:
			color.a = 1.0
		draw_line(lineNodes[i], lineNodes[i+1], color, 3)
