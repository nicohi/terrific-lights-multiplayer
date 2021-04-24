extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EasySetting_pressed():
	get_tree().change_scene("res://MainMenuEasy.tscn") # Replace with function body.
	

func _on_MediumSetting_pressed():
	get_tree().change_scene("res://MainMenuMedium.tscn")


func _on_HardSetting_pressed():
	get_tree().change_scene("res://MainMenuHard.tscn")
