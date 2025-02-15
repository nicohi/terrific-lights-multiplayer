extends Node2D

signal openDifficultyMenu

onready var start = $StartButton
onready var difficulty = $DifficultyButton
onready var exit = $ExitButton

onready var standing1 = $FirstPlayer/Standing
onready var walking1 = $FirstPlayer/Walking

onready var standing2 = $FirstPlayer2/Standing
onready var walking2 = $FirstPlayer2/Walking

onready var standing3 = $FirstPlayer3/Standing
onready var walking3 = $FirstPlayer3/Walking

onready var standing4 = $FirstPlayer4/Standing
onready var walking4 = $FirstPlayer4/Walking

var map = preload("res://Map/MapMulti.tscn")

func _ready():
	start.connect("button_pressed", self, "_on_StartButton_pressed")
	difficulty.connect("button_pressed", self, "_on_DiffButton_pressed")
	exit.connect("button_pressed", self, "_on_ExitButton_pressed")
	

	changeVisibility(1)
	
func _show_map():
	EngineConfig.car_engines_on = 0
	$AudioStreamPlayer.stop()
	map.show()
		
func _hide_map():
	map.hide()
	map = preload("res://Map/MapMulti.tscn")
	start.visible = true
	
func _on_ExitButton_pressed():
	get_tree().quit()

func _on_DiffButton_pressed():
	emit_signal("openDifficultyMenu")

func _on_StartButton_pressed():
	start.visible = false
	map = map.instance()
	add_child(map)
	map.hide()
	map.connect("quit", self, "_hide_map")
	map.connect("player_joined", self, "changeVisibility")
	map.connect("match_started", self, "_show_map")

#func _on_Standing_visibility_changed():
func changeVisibility(players):
	if players >= 1:
		walking1.visible = 1
		standing1.visible = 0
	else:
		walking1.visible = 0
		standing1.visible = 1
	if players >= 2:
		walking2.visible = 1
		standing2.visible = 0
	else:
		walking2.visible = 0
		standing2.visible = 1
	if players >= 3:
		walking3.visible = 1
		standing3.visible = 0
	else:
		walking3.visible = 0
		standing3.visible = 1
	if players >= 4:
		walking4.visible = 1
		standing4.visible = 0
	else:
		walking4.visible = 0
		standing4.visible = 1
	
#	if players == 1:
#		walking1.visible = 1
#		standing1.visible = 0
#		walking2.visible = 0
#		standing2.visible = 1
#		walking3.visible = 0
#		standing3.visible = 1
#		walking4.visible = 0
#		standing4.visible = 1
#	elif players == 2:
#		walking1.visible = 1
#		standing1.visible = 0
#		walking2.visible = 1
#		standing2.visible = 0
#		walking3.visible = 0
#		standing3.visible = 1
#		walking4.visible = 0
#		standing4.visible = 1
#	elif players == 3:
#		walking1.visible = 1
#		standing1.visible = 0
#		walking2.visible = 1
#		standing2.visible = 0
#		walking3.visible = 1
#		standing3.visible = 0
#		walking4.visible = 0
#		standing4.visible = 1
#	elif players == 4:
#		walking1.visible = 1
#		standing1.visible = 0
#		walking2.visible = 1
#		standing2.visible = 0
#		walking3.visible = 1
#		standing3.visible = 0
#		walking4.visible = 1
#		standing4.visible = 0
	
