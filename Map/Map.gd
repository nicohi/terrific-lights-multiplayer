extends Node2D

const N_CARS = 128


var cars = []
var timer
var total_points = 0
var cars_passed = 0

onready var pausePopUp = $PausePopup
onready var scoreDisplay = $ScoreDisplay
onready var backgroundMusic = $BackgroundMusic
signal score_changed(total_score, cars_passed)

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_release_a_car")
	timer.autostart = true


func _create_cars():
	var car_scene = load("res://Car/Car.tscn")
	
	for i in N_CARS:
		var car = car_scene.instance()
		cars.push_back(car)
		car.connect("car_exited", self, "_reset_car")
		car.connect("game_over", self, "_game_over")
		add_child(car)

func _ready():
	self.connect("score_changed", scoreDisplay, "update_score")
	
	var window_size = get_viewport().get_visible_rect().size

	_create_cars()
	
	randomize()
	backgroundMusic.play()
	
func _reset_car(car, points):
	cars.push_back(car)
	total_points += points
	cars_passed += 1
	
	emit_signal("score_changed", total_points, cars_passed)

func _game_over():
	print("game over")

func _release_a_car():
	if cars.size():
		var car = cars.pop_front()
		car._go()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		pausePopUp.popup_centered()

func _on_BackgroundMusic_finished():
	backgroundMusic.play()
