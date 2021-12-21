extends Label

func _ready():
	self.text = "Score:\n no player has score points"

func update_score(scores):
	var score = "Score:\n"
	for id in scores:
		var cars_passed = scores[id]["cars_passed"]
		var s = scores[id]["score"]
		score = score + "	Player" + str(id) + " has passed " + str(cars_passed) + " cars and scored " +  str(s) + " points.\n"
	self.text = score
