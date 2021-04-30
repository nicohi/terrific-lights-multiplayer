extends Node

signal zero_points

const MAX_POINTS := 99

var timer: Timer
var points := MAX_POINTS

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_reduce_point")

func start():
	timer.start()

func stop():
	timer.stop()

func reset():
	points = MAX_POINTS

func _reduce_point():
	points -= 1

	if points <= 0:
		emit_signal("zero_points")
