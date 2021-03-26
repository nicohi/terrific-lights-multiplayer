extends Node2D

const N_CARS = 64

var cars = []
var timer
var points = 0

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_release_a_car")
	timer.autostart = true
	
func _ready():
	var window_size = OS.window_size
	var carscene = load("res://Car/Car.tscn")
	
	for i in N_CARS:
		var car = carscene.instance()
		cars.push_back(car)
		car.connect("car_exited", self, "_reset_car")
		add_child(car)
		
	randomize()
	
func _reset_car(car):
	cars.push_back(car)
	points += 1
	print(points)
	
func _release_a_car():
	if cars.size():
		var car = cars.pop_front()
		car._go()
