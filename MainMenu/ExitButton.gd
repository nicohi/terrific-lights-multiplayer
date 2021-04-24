extends Button

export(String) var scene_to_load

onready var sprite = $Sprite

func _on_Button_mouse_entered():
	sprite.frame = 0

func _on_Button_mouse_exited():
	sprite.frame = 1
