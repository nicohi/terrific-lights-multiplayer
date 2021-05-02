extends Popup

onready var hoverAudio = $ButtonAudio/OnHover
onready var clickAudio = $ButtonAudio/OnClick
onready var retryButton = $Options/RetryButton
onready var returnButton = $Options/ReturnToMenuButton

func _ready():
	for button in [retryButton, returnButton]:
		var b = button as Button
		b.connect("mouse_entered", self, "_on_hover")
		b.connect("pressed", self, "_on_click")

func _on_hover():
	hoverAudio.play()
	
func on_click():
	clickAudio.play()
