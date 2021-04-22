extends Node

class_name Route

var tiles = []

func _init(tileList):
	tiles = tileList

func getTileAtInd(ind: int):
	if (ind >= tiles.size()):
		return null
	return tiles[ind]
