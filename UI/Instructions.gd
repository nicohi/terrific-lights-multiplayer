extends Polygon2D

signal instructions_closed

onready var hoverAudio := $ButtonAudio/OnHover
onready var clickAudio := $ButtonAudio/OnClick

func _on_Button_pressed():
	self.visible = false
	clickAudio.play()
	
	emit_signal("instructions_closed")


func _on_Button_mouse_entered():
	hoverAudio.play()
