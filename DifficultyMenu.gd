extends Node2D

signal difficulty_set(difficulty)

onready var diffEasy = $DiffEasy
onready var diffMedium = $DiffMedium
onready var diffHard = $DiffHard

func _ready():
	diffEasy.connect("button_pressed", self, "_on_EasySetting_pressed")
	diffMedium.connect("button_pressed", self, "_on_MediumSetting_pressed")
	diffHard.connect("button_pressed", self, "_on_HardSetting_pressed")


func _on_EasySetting_pressed():
	Globals.CARS_PER_SEC = 2
	emit_signal("difficulty_set", Globals.DIFFICULTY_EASY)
	

func _on_MediumSetting_pressed():
	Globals.CARS_PER_SEC = 3
	emit_signal("difficulty_set", Globals.DIFFICULTY_MEDIUM)


func _on_HardSetting_pressed():
	Globals.CARS_PER_SEC = 4
	emit_signal("difficulty_set", Globals.DIFFICULTY_HARD)
