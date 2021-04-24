extends Node2D

onready var mainMenu = $MainMenuEasy
onready var difficultyMenu = $DifficultyMenu
onready var difficultySprite = $MainMenuEasy/DifficultyButton/Button/Sprite

var easyDiffTexture = preload("res://MainMenu/OnOffDiffEasy.png")
var mediumDiffTexture = preload("res://MainMenu/OnOffDiffMedium.png")
var hardDiffTexture = preload("res://MainMenu/OnOffDiffHard.png")

func _ready():
	difficultyMenu.visible = false
	mainMenu.visible = true
	mainMenu.connect("openDifficultyMenu", self, "_openDifficultyMenu")
	difficultyMenu.connect("difficulty_set", self, "_onDifficultySet")
	
func _openDifficultyMenu():
	mainMenu.visible = false
	difficultyMenu.visible = true

func _onDifficultySet(difficulty):
	match difficulty:
		Globals.DIFFICULTY_EASY:
			difficultySprite.texture = easyDiffTexture
		Globals.DIFFICULTY_MEDIUM:
			difficultySprite.texture = mediumDiffTexture
		Globals.DIFFICULTY_HARD:
			difficultySprite.texture = hardDiffTexture

	mainMenu.visible = true
	difficultyMenu.visible = false
