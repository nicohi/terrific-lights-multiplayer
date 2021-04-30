extends Node

var blackCar = preload("res://Car/TriotemplateBlackTurns.png")
var blueCar = preload("res://Car/TriotemplateBlueTurns.png")
var redCar = preload("res://Car/TriotemplateRedTurn.png")
var tanCar = preload("res://Car/TriotemplateTanTurns.png")
var greenCar = preload("res://Car/TriotemplateGreenTurns.png")
var orangeCar = preload("res://Car/TriotemplateOrangeTurns.png")
var purpleCar = preload("res://Car/TriotemplatePurpleTurns.png")
var tealCar = preload("res://Car/TriotemplateTealTurns.png")
var whiteCar1 = preload("res://Car/TriotemplateWhite1Turns.png")
var whiteCar2 = preload("res://Car/TriotemplateWhite2Turns.png")

var carTextures = [
	blackCar,
	blueCar,
	redCar,
	tanCar,
	greenCar,
	orangeCar,
	purpleCar,
	tealCar,
	whiteCar1,
	whiteCar2
]

# Returns a random texture for the car.
func get_texture():
	return carTextures[randi() % carTextures.size()]
