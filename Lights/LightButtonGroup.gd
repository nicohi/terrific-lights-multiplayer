extends Node2D

class_name LightButtonGroup

var right_turn: LightButton
var left_turn: LightButton

func set_lights(
	right_turn_texture_off: String,
	right_turn_texture_on: String,
	left_turn_texture_off: String,
	left_turn_texture_on: String,
	x: float,
	y: float
):
	var LightButtonScene = load("res://Lights/LightButton.tscn")
	
	right_turn = LightButtonScene.instance()
	left_turn = LightButtonScene.instance()
	
	right_turn.set_textures(right_turn_texture_off, right_turn_texture_on)
	left_turn.set_textures(left_turn_texture_off, left_turn_texture_on)
	
	right_turn.set_pair(left_turn)
	left_turn.set_pair(right_turn)
	
	add_child(right_turn)
	add_child(left_turn)
	
	right_turn.position = Vector2(x, y)
	left_turn.position = Vector2(x + 200, y)
	
