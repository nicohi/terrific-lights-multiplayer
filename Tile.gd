extends Area2D

class_name Tile

onready var timer = $Timer
var coordinates = Vector2.ZERO
var is_crossing: bool
var takingCar: Car

var incoming

func _ready():
	takingCar = null
	is_crossing = false
	incoming = Globals.ALL

func setCoordinates(x, y):
	coordinates = Vector2(x, y)

func isFree() -> bool:
	if self.get_overlapping_bodies().size() == 0 and takingCar == null:
		return true
	else:
		return false
	
func mayEnter(movingFrom) -> bool:
	if incoming == Globals.ALL:
		return true
	elif incoming == Globals.NONE:
		return false
	else:
		return movingFrom == incoming

func _on_Tile_body_entered(body):
	if self == body.getRoute().getTileAtInd(body.ind + 1):
		body.getRoute().getTileAtInd(body.ind).takingCar = null
		body.ind += 1
		self.takingCar = body

func positionFromTile(tile: Tile):
	if self.coordinates.x < tile.coordinates.x:
		return Globals.WEST
	elif self.coordinates.x > tile.coordinates.x:
		return Globals.EAST
	elif self.coordinates.y < tile.coordinates.y:
		return Globals.NORTH
	elif self.coordinates.y > tile.coordinates.y:
		return Globals.SOUTH
