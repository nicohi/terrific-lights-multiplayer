extends Area2D

class_name Tile

var free setget , isFree
# Another node in the scene can be exported as a NodePath.
export(NodePath) var node_path
# Do take note that the node itself isn't being exported -
# there is one more step to call the true node:
onready var nextTile = get_node(node_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	free = true

func isFree():
	return free
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
