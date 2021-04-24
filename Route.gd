extends Node

class_name Route

var tiles = []

func _init(tileList):
	tiles = tileList

func getTileAtInd(ind: int):
	if (ind >= tiles.size()):
		return null
	
	return tiles[ind]["tile"]

func getNextTurnAtInd(ind: int):
	if (ind >= tiles.size()):
		return Globals.STRAIGHT
	
	return tiles[ind]["turn"]

func isTurningAtInd(ind: int) -> bool:
	if (ind >= tiles.size()):
		return false
	
	return tiles[ind]["doTurn"]
