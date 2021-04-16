extends Area2D

class_name Tile

var free setget , isFree
#export(NodePath) var node_path
#onready var nextTile = get_node(node_path)

func _ready():
	free = true

func isFree():
	return free


func _on_Tile_body_entered(body):
	Globals.entered += 1
#	var car = body as Car
	body.ind += 1
	print("ENTERED: ", Globals.entered)
