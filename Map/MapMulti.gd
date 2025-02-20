extends Node2D

const N_CARS = 128
const GAME_TIME = 300.0

var cars = []
var timer

onready var pausePopUp = $PausePopup
onready var scoreDisplay = $ScoreDisplay
onready var road = $Road
onready var gameTimer = $GameTimer
onready var timeDisplay = $TimeDisplay
onready var carExitAudio = $CarExitAudio
onready var gameOverPopUp = $GameOverPopupMenu
onready var darken = $Darken
onready var carStorage = $Cars
onready var instructions = $Instructions
onready var instructionButton = $Instructions/Button
onready var gameOverTune = $GameOverAudio
onready var victoryTune = $VictoryAudio
onready var _relay_client = $MatchmakingClient

var scores = {}

signal score_changed(total_score, cars_passed)
signal player_joined(count)
signal match_started()
signal quit()

func _init():
	randomize()
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_release_a_car")
	timer.autostart = true
	Globals.score = 0
	Globals.cars_passed = 0

# Spawns all the Cars right at the beginning, but outside the map
func _create_cars():
	var car_scene = load("res://Car/Car.tscn")

	for i in N_CARS:
		var car = car_scene.instance()
		cars.push_back(car)
		car.connect("car_exited", self, "_reset_car")
		car.connect("game_over", self, "_game_over")
		car.setRoute(road.randomRoute())
		add_child_below_node(carStorage, car)

func _ready():
	gameOverPopUp.returnButton.connect("pressed", self, "_on_QuitButton_pressed")
	pausePopUp.quitButton.connect("pressed", self, "_on_QuitButton_pressed")
	#Initialize networking
	_relay_client.connect("on_message", self, "_on_message")
	_relay_client.connect("on_players_ready", self, "_on_players_ready")
	_relay_client.connect_to_server()
	print("connecting to matchmaking server")
	
	# TODO add and show lobby screen here
	# number of currently connected players is accessible from _relay_client._players
	# match size is accessible from _relay_client._match_size

func _on_message(message : Message):
	var cont = message.content
	print(cont)
	if (message.server_login): return
	if (message.match_start): return
	else:
		if (cont.has("type")):
			#Add cases for message types here
			if (cont["type"] == "player_count"):
				emit_signal("player_joined", cont["count"])
			if (cont["type"] == "score"):
				update_score_from_message(cont)

func update_score_from_message(msg):
	scores[msg["id"]] = msg["data"]
	read_scores()
	
func read_scores():
	print("CURRENT SCORES:")
	for id in scores:
		var cars_passed = scores[id]["cars_passed"]
		var score = scores[id]["score"]
		print("	Player", id, " has passed ", cars_passed, " cars and scored ", score, " points.")
	$MultiScore.update_score(scores)


func _on_players_ready():
	_relay_client.disconnect_from_server()

	var peers = _relay_client._match

	print("MATCH STARTED ", peers)

	#Start game
	self.connect("score_changed", scoreDisplay, "update_score")
	instructions.connect("instructions_closed", self, "_handle_instructions_closed")

	timeDisplay.updateTime(GAME_TIME)
	var _window_size = get_viewport().get_visible_rect().size

	_create_cars()

	randomize()

	if (
		Globals.current_difficulty == Globals.DIFFICULTY_EASY and
		not Globals.instructions_shown
	):
		instructions.visible = true
		#get_tree().paused = true
	emit_signal("match_started")

func send_message(type, data):
	var msg = Message.new()
	msg.is_echo = true
	msg.content = {}
	msg.content["id"] = _relay_client._id
	msg.content["time"] = OS.get_unix_time()
	msg.content["type"] = type
	msg.content["data"] = data
	_relay_client.send_data(msg)

func _handle_instructions_closed():
	if (
		not Globals.instructions_shown and
		Globals.current_difficulty == Globals.DIFFICULTY_EASY
	):
		Globals.instructions_shown = true
		get_tree().paused = false
	else:
		pausePopUp.visible = true

func _reset_car(car, points):
	carExitAudio.play()
	cars.push_back(car)
	Globals.score += points
	Globals.cars_passed += 1

	send_message("score", {"score": Globals.score, "cars_passed": Globals.cars_passed})
	emit_signal("score_changed", Globals.score, Globals.cars_passed)
	car.setRoute(road.randomRoute())

func _game_over(car: Car):
	darken.show()
	get_tree().paused = true
	gameOverPopUp.popup_centered()
	car.set_as_toplevel(true)
	var carSprite = car.find_node("Sprite")
	carSprite.modulate = Color(2, 0, 0, 1)
	var gameOverLabel = gameOverPopUp.find_node("GameOverLabel")
	gameOverLabel.text = "GAME OVER"
	gameOverLabel.add_color_override("font_color", Color(1, 0, 0, 1))
	gameOverPopUp.find_node("ScoreLabel").text = ""
	gameOverTune.play()

# Every 12 seconds, release a number of Cars dependent on the difficulty level
func _release_a_car():
	if gameTimer.is_stopped():
		gameTimer.start(GAME_TIME)

#	timer.wait_time = 12
#	if cars.size():
#		for _i in range(Globals.CARS_PER_SEC):
#			var car = cars.pop_front()
#			if car != null and car.route.getTileAtInd(0).isFree():
#				car.position = car.route.getTileAtInd(0).position
#				car._go()
	timer.wait_time = 12 / Globals.CARS_PER_SEC
	if cars.size():
		var car = cars.pop_front()
		if car != null and car.route.getTileAtInd(0).isFree():
			car.position = car.route.getTileAtInd(0).position
			car._go()

func _physics_process(delta):
	timeDisplay.updateTime(gameTimer.time_left)
	if Input.is_action_just_pressed("ui_cancel"): # Checks for pausing
		get_tree().paused = true
		darken.show()
		pausePopUp.popup_centered()


func _on_GameTimer_timeout():
	darken.show()
	get_tree().paused = true
	gameOverPopUp.popup_centered()
	var gameOverLabel = gameOverPopUp.find_node("GameOverLabel")
	gameOverLabel.text = "VICTORY"
	gameOverLabel.add_color_override("font_color", Color(0, 1, 0, 1))
	gameOverPopUp.find_node("ScoreLabel").text = "Score: " + str(Globals.score)
	victoryTune.play()

func _on_ReturnToMenuButton_pressed():
	darken.hide()
	get_tree().paused = false
	#get_tree().change_scene("res://MainMenu/MainMenuMulti.tscn")
	gameOverPopUp.hide()
	emit_signal("quit")

# Starts the current game mode from the beginning
func _on_RetryButton_pressed():
	EngineConfig.car_engines_on = 0
	#get_tree().change_scene("res://Map/MapMulti.tscn")
	get_tree().paused = false


func _on_ResumeButton_pressed():
	#resumes game from where it was when pause was pressed, hiding pausemenu.
	darken.hide()
	pausePopUp.hide()
	get_tree().paused = false


func _on_RestartButton_pressed():
	#Restarts the map by reloading the scene and removing the pause-paralysis.
	#get_tree().change_scene("res://Map/MapMulti.tscn")
	#get_tree().paused = false
	#EngineConfig.car_engines_on = 0
	pass


func _on_QuitButton_pressed():
	#Returns to main menu. Pause flased in order to return from pause-paralysis.
	darken.hide()
	get_tree().paused = false
	gameOverPopUp.hide()
	emit_signal("quit")


func _on_InstructionsButton_pressed():
	instructionButton.text = "BACK"
	pausePopUp.visible = false
	instructions.visible = true
