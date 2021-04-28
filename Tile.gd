extends Area2D

class_name Tile

onready var timer = $Timer
var coordinates = Vector2.ZERO
var is_crossing: bool # true if the Tile is located in a crossing
var takingCar: Car # A Car can mark the Tile as taken in order to ensure passage, otherwise null

var incoming # The direction a Car must be moving in to be granted passage to the Tile

func _ready():
	takingCar = null
	is_crossing = false
	incoming = Globals.ALL

func setCoordinates(x, y):
	coordinates = Vector2(x, y)

# The Tile is free to enter if no Cars (overlapping bodies) are on it,
# and if no Car has marked the Tile as taken.
func isFree() -> bool:
	if self.get_overlapping_bodies().size() == 0 and takingCar == null:
		return true
	else:
		return false

# 
func mayEnter(movingFrom) -> bool:
	if incoming == Globals.ALL:
		return true
	elif incoming == Globals.NONE:
		return false
	else:
		return movingFrom == incoming

# Whenever a Car enters the Tile, and the Tile is in the Car's Route,
# the Tile is marked as taken by the Car that entered,
# the Tile that the Car previously occupied is free.
func _on_Tile_body_entered(body):
	if self == body.getRoute().getTileAtInd(body.ind + 1):
		body.getRoute().getTileAtInd(body.ind).takingCar = null
		body.ind += 1
		self.takingCar = body

# Returns the direction that the checked Tile is in when compared to the other Tile.
# Used when determining a Car's moving direction.
func positionFromTile(tile: Tile):
	if self.coordinates.x < tile.coordinates.x:
		return Globals.WEST
	elif self.coordinates.x > tile.coordinates.x:
		return Globals.EAST
	elif self.coordinates.y < tile.coordinates.y:
		return Globals.NORTH
	elif self.coordinates.y > tile.coordinates.y:
		return Globals.SOUTH
