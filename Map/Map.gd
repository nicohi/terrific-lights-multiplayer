extends Node2D

const N_CARS = 128

var cars = []
var timer

onready var pausePopUp = $PausePopup
onready var scoreDisplay = $ScoreDisplay
onready var road = $Road
onready var gameTimer = $GameTimer
onready var timeDisplay = $TimeDisplay
signal score_changed(total_score, cars_passed)

func _init():
	randomize()
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_release_a_car")
	timer.autostart = true
	Globals.score = 0
	Globals.cars_passed = 0


func _create_cars():
	var car_scene = load("res://Car/Car.tscn")

	for i in N_CARS:
		var car = car_scene.instance()
		cars.push_back(car)
		car.connect("car_exited", self, "_reset_car")
		car.connect("game_over", self, "_game_over")
		car.setRoute(road.randomRoute())
		add_child(car)

func _ready():
	self.connect("score_changed", scoreDisplay, "update_score")

	timeDisplay.updateTime(300.0)
	var _window_size = get_viewport().get_visible_rect().size

	_create_cars()

	randomize()

func _reset_car(car, points):
	cars.push_back(car)
	Globals.score += points
	Globals.cars_passed += 1

	emit_signal("score_changed", Globals.score, Globals.cars_passed)
	car.setRoute(road.randomRoute())

func _game_over():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")

func _release_a_car():
	if gameTimer.is_stopped():
		gameTimer.start(300.0)

	timer.wait_time = 5
	if cars.size():
		for _i in range(Globals.CARS_PER_SEC):
			var car = cars.pop_front()
			if car != null and car.getRoute().getTileAtInd(0).isFree():
				car.position = car.getRoute().getTileAtInd(0).position
				car._go()

func _physics_process(delta):
	timeDisplay.updateTime(gameTimer.time_left)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		pausePopUp.popup_centered()


func _on_GameTimer_timeout():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
