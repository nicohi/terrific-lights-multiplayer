extends Popup

onready var resumeButton = $ResumeButton

func _ready():
	resumeButton.connect("pressed", self, "_resume_button_pressed")
	self.connect("modal_closed", self, "_resume_button_pressed")

func _resume_button_pressed():
	self.hide()
	get_tree().paused = false
