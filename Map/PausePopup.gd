extends Popup

onready var hoverAudio = $ButtonAudio/OnHover
onready var clickAudio = $ButtonAudio/OnClick
onready var resumeButton = $VBoxContainer/ResumeButton
onready var restartButton = $VBoxContainer/RestartButton
onready var instructionButton = $VBoxContainer/InstructionsButton
onready var quitButton = $VBoxContainer/QuitButton

func _ready():
	for button in [resumeButton, restartButton, instructionButton, quitButton]:
		var b = button as Button
		b.connect("mouse_entered", self, "_on_hover")
		b.connect("pressed", self, "_on_click")

func _on_hover():
	hoverAudio.play()
	
func on_click():
	clickAudio.play()
