extends Control

onready var score = $Score
onready var carsPassed = $CarsPassed

func _ready():
	score.text = str(Globals.score)
	carsPassed.text = str(Globals.cars_passed)

func update_score(score_, cars_passed_):
	score.text = str(score_)
	carsPassed.text = str(cars_passed_)
