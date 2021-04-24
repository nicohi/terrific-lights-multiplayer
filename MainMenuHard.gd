extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#for button in $Control/Buttons.get_children():
		#button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	 # Replace with function body.
#func on_Button_pressed(scene_to_load):
	#get_tree().change_scene(scene_to_load)
	pass




func _on_ExitButton_pressed():
	get_tree().quit()


func _on_DiffButton_pressed():
	get_tree().change_scene("res://DifficultyMenu.tscn")


func _on_StartButton_pressed():
	get_tree().change_scene("res://Map/Map.tscn")
