extends Area2D

class_name Tile

onready var timer = $Timer
var free setget , isFree
var er: bool = true
var el: bool = true
var wr: bool = true
var wl: bool = true
var nr: bool = true
var nl: bool = true
var sr: bool = true
var sl: bool = true

func _ready():
	free = true

func freeTile():
	timer.start(0.5)

func isFree() -> bool:
	if self.get_overlapping_bodies().size() == 0:
		free = true
	else:
		free = false
	return free and er and el and wr
	
func stopAllTraffic():
	er = false
	el = false
	wr = false
	wl = false
	nr = false
	nl = false
	sr = false
	sl = false

func _on_Tile_body_entered(body):
	body.getRoute().getTileAtInd(body.ind).freeTile()
	body.ind += 1
	self.free = false

func _on_Timer_timeout():
	self.free = true
