extends StaticBody2D

# Obstacle
# An object manipulated by the player to redirect the flow of Organisms. Can be
# clicked and dragged. Generated from an ObstaclePile

signal dragged;
signal released;

var isDragged = false; # Whether or not the obstacle is currently being dragged
var isRotating = false;
var dragOffset;		   # The distance from the origin of the obstacle to the mouse cursor
					   # when it is dragged
var rotationOrigin;
var prevMousePosition = Vector2.ZERO; # Used to calculate mouse delta/velocity for hitting organisms
var mouseDelta = Vector2.ZERO;
var min_y_value = 0;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	
# Processes mouse inputs on the screen
func _input(event):
	
	# Stop dragging the obstacle when the LMB is released
	if (event.is_action_released("mouse_left")):
		if (isDragged):
			toggleCollisions();
			isDragged = false;
			
			emit_signal("released")
			
	# Stop rotating the obstacle when the RMB is released
	if (event.is_action_released("mouse_right")):
		if (isRotating):
			toggleCollisions();
			isRotating = false;


# Processes mouse inputs on the obstacle itself
func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton):
		
		if (event.button_index == BUTTON_LEFT and event.pressed):
			if (!isDragged):
				dragOffset = position - get_global_mouse_position();
				toggleCollisions();
				isDragged = true;
				get_parent().get_parent().get_node("ClickSound").play();
				emit_signal("dragged")
				
		if (event.button_index == BUTTON_RIGHT and event.pressed):
			if (!isRotating):
				rotationOrigin = get_global_mouse_position();
				toggleCollisions();
				isRotating = true;

# Toggles the collisions and opacity 	
func toggleCollisions():
#	if (!$CollisionPolygon2D.disabled):
#		$CollisionPolygon2D.disabled = true;
#		$ObstacleGraphic.setOpacity(0.5);
#	else:
#		$CollisionPolygon2D.disabled = false;
#		$ObstacleGraphic.setOpacity(1.0);
	$CollisionPolygon2D.disabled = !$CollisionPolygon2D.disabled;
	pass
				
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and isDragged:
		var new_position = get_global_mouse_position() + dragOffset;
		new_position.y = min(new_position.y,min_y_value);
		position = new_position;
		
	# Adjust rotation of triangle based on mouse position
	if Input.is_mouse_button_pressed(BUTTON_RIGHT) and isRotating:
		
		var rotationAnchorDist = (get_global_mouse_position() - rotationOrigin).length()
		# Helps prevent rapid and disorientating spinning when the mouse is too close to the
		# triangle
		if (rotationAnchorDist > 10):
			var opp = get_global_mouse_position().y - rotationOrigin.y;
			var adj = get_global_mouse_position().x - rotationOrigin.x;
			var newRotation = atan2(opp, adj);
			
			$ObstacleGraphic.rotation = newRotation;
			$CollisionPolygon2D.rotation = newRotation;
			
	# Calculating mouse delta
	mouseDelta = get_global_mouse_position() - prevMousePosition;
	prevMousePosition = get_global_mouse_position();
	
	#print(mouseDelta.length());

func _on_Area2D_body_entered(body):
	if (body.name.find("Organism") > -1):
		body.apply_central_impulse(mouseDelta  * 10)
