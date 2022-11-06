extends Node2D


func setOpacity(alpha):
	for child in get_children():
		child.color.a = alpha;
