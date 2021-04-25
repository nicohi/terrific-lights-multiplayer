extends Button

export(String) var scene_to_load

onready var sprite = $Sprite
onready var mouseEnterAudio = $MouseEnter
onready var mouseExitAudio = $MouseExit

func _on_Button_mouse_entered():
	mouseEnterAudio.play()
	sprite.frame = 0

func _on_Button_mouse_exited():
	sprite.frame = 1
