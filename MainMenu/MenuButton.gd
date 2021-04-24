extends Node2D

signal button_pressed

func _on_Button_pressed():
	emit_signal("button_pressed")
