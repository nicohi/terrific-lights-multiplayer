extends Node2D

onready var carHorn1 := $CarHorn1
onready var carHorn2 := $CarHorn2
onready var honkTimer = $HonkTimer

onready var carHorns = [carHorn1, carHorn2]

var beeped = false

func honk():
	if not beeped:
		beeped = true
		honkTimer.start(2.0)

func cancel_honk():
	beeped = false
	honkTimer.stop()

func _on_HonkTimer_timeout():
	carHorns.shuffle()
	carHorns[0].play()
