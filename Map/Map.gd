extends Node2D

const N_CARS = 64


var cars = []
var timer
var total_points = 0

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
	var window_size = OS.window_size

	_create_cars()
	
	randomize()
	
func _reset_car(car, points):
	cars.push_back(car)
	total_points += points
	
	print(points)
	print(total_points)

func _game_over():
	print("game over")

func _release_a_car():
	if cars.size():
		var car = cars.pop_front()
		car._go()
