extends Control

onready var timeLeftDisplay = $TimeLeft

func updateTime(timeLeft: float):
	var mins = (timeLeft / 60) as int
	var secs = fmod(timeLeft, 60) as int
	var secsAsStr = str(secs)
	
	if secs < 10:
		secsAsStr = "0" + secsAsStr
	
	timeLeftDisplay.text = str(mins) + ":" + secsAsStr
