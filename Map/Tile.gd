extends Area2D

class_name Tile

var free setget , isFree
#export(NodePath) var node_path
#onready var nextTile = get_node(node_path)

func _ready():
	free = true

func isFree():
	return free
