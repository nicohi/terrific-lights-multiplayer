extends Node2D

class_name LightButton

signal light_clicked(light)

onready var lightOn = $LightOn
onready var lightOff = $LightOff
onready var btnPressedAudio = $BtnPressedAudio

var sound = false


func handle_light_up(light: LightButton):
	if light == self:
		if sound:
			btnPressedAudio.play()
		lightOn.visible = true
		lightOff.visible = false
	else:
		lightOff.visible = true
		lightOn.visible = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if lightOn == null or lightOn.texture == null:
			return
		
		var spriteSize: Vector2 = lightOn.texture.get_size()
		var event_pos: Vector2 = event.position
		var pos: Vector2 = self.position - spriteSize / 2
		
		if event_pos.x >= pos.x and event_pos.x <= pos.x + spriteSize.x and event_pos.y >= pos.y and event_pos.y <= pos.y + spriteSize.y:
			emit_signal("light_clicked", self)
