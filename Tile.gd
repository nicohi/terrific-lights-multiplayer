extends Area2D

class_name Tile

onready var timer = $Timer
var coordinates = Vector2.ZERO
var is_crossing: bool
var takingCar: Car

enum { NONE, ALL, NORTH, EAST, SOUTH, WEST }
enum { STRAIGHT_OR_RIGHT, LEFT_TURN }
var incoming
var leaving

func _ready():
	takingCar = null
	is_crossing = false
	incoming = ALL
	leaving = STRAIGHT_OR_RIGHT

func setCoordinates(x, y):
	coordinates = Vector2(x, y)

func isFree() -> bool:
	if self.get_overlapping_bodies().size() == 0 and takingCar == null:
		return true
	else:
		return false

func mayEnter(movingFrom, turningTo) -> bool:
	var movingFromOK
	if incoming == ALL:
		movingFromOK = true
	elif incoming == NONE:
		movingFromOK = false
	else:
		movingFromOK = movingFrom == incoming
#	print(turningTo,leaving)
	return movingFromOK and turningTo == leaving

func _on_Tile_body_entered(body):
	body.getRoute().getTileAtInd(body.ind).takingCar = null
	body.ind += 1
	self.takingCar = body
#	self.free = false

func positionFromTile(tile: Tile):
#	print(self.coordinates.x, " ", tile.coordinates.x)
	if self.coordinates.x < tile.coordinates.x:
		return WEST
	elif self.coordinates.x > tile.coordinates.x:
		return EAST
	elif self.coordinates.y < tile.coordinates.y:
		return NORTH
	elif self.coordinates.y > tile.coordinates.y:
		return SOUTH
