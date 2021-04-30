extends Node2D

signal openDifficultyMenu

onready var start = $StartButton
onready var difficulty = $DifficultyButton
onready var exit = $ExitButton

func _ready():
	start.connect("button_pressed", self, "_on_StartButton_pressed")
	difficulty.connect("button_pressed", self, "_on_DiffButton_pressed")
	exit.connect("button_pressed", self, "_on_ExitButton_pressed")

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_DiffButton_pressed():
	emit_signal("openDifficultyMenu")

func _on_StartButton_pressed():
	EngineConfig.car_engines_on = 0
	get_tree().change_scene("res://Map/Map.tscn")
