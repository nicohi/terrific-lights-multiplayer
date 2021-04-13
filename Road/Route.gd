extends Node

class_name Route

var tiles = []
var cars = []

func _init(tileList):
	tiles = tileList
	for i in range(tiles.size()):
		cars.append([])

func _ready():
	pass

func _process(delta):
	for i in range(cars.size()):
		if cars[i] != null:
			if i + 1 < cars.size():
				if cars[i + 1] == null:
					# emit continue signal
					pass
				else:
					# emit stopping signal
					pass
			else:
				# end reached; despawn car
				pass
