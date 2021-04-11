extends Control

onready var score = $Score
onready var carsPassed = $CarsPassed

func update_score(score_, cars_passed_):
	score.text = str(score_)
	carsPassed.text = str(cars_passed_)
