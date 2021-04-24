extends Node2D

class_name LightButtonGroup

signal lit(light)

onready var northSouthRight = $NorthSouthRight
onready var northSouthLeft = $NorthSouthLeft
onready var eastWestRight = $EastWestRight
onready var eastWestLeft = $EastWestLeft

func _ready():
	for light in [northSouthRight, northSouthLeft, eastWestRight, eastWestLeft]:
		self.connect("lit", light, "handle_light_up")
		light.connect("light_clicked", self, "handle_light_clicked")
	
	emit_signal("lit", eastWestLeft)

func begin():
	emit_signal("lit", eastWestLeft)

func handle_light_clicked(light: LightButton):
	emit_signal("lit", light)
