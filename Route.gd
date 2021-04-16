extends Node

class_name Route

var tiles = []
#var cars = []

func _init(tileList):
	tiles = tileList
#	for i in range(tiles.size()):
#		cars.append([])

func getTileAtInd(ind: int) -> Tile:
	if (ind >= tiles.size()):
		return null
	return tiles[ind]

func _ready():
	pass

#func _process(delta):
#	for i in range(cars.size()):
#		if cars[i] != null:
#			if i + 1 < cars.size():
#				# signal for 
#				pass
#			else:
#				# end reached; despawn car
#				pass
