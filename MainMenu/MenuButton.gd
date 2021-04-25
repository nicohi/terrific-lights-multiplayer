extends Node2D

signal button_pressed

onready var btnPressedAudio = $BtnPressed

func _on_Button_pressed():
	btnPressedAudio.play()
	emit_signal("button_pressed")
