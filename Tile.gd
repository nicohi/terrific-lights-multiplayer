extends Area2D

class_name Tile

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

func isFree() -> bool:
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
	Globals.entered += 1
	body.ind += 1
	self.free = false


func _on_Tile_body_exited(body):
	self.free = true
