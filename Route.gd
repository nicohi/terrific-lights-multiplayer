extends Node

class_name Route

var tiles = []

# Creates a new route from a set of tiles.
# Each tile has info on its position, the turn to be made during or after
# the current tile, and whether the car is turning in this tile.
func _init(tileList):
	tiles = tileList

# Get the tile at a given index.
func getTileAtInd(ind: int):
	if (ind >= tiles.size()):
		return null

	return tiles[ind]["tile"]

# Get the turn to be made during or after the tile at a given index.
func getNextTurnAtInd(ind: int):
	if (ind >= tiles.size()):
		return Globals.STRAIGHT

	return tiles[ind]["turn"]

# Returns true if the car is turning in the tile at the given index.
func isTurningAtInd(ind: int) -> bool:
	if (ind >= tiles.size()):
		return false

	return tiles[ind]["doTurn"]
