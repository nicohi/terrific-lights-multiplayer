extends Node2D

const N_CARS = 64

var cars = []
var timer
var total_points = 0

var lights = [
	[
		"res://Lights/Light_option_11.jpg",
		"res://Lights/Light_option_11_Light.jpg",
		"res://Lights/Light_option_31.jpg",
		"res://Lights/Light_option_31_Light.jpg",
		100,
		100
	],
	[
		"res://Lights/Light_option_12.jpg",
		"res://Lights/Light_option_12_Light.jpg",
		"res://Lights/Light_option_32.jpg",
		"res://Lights/Light_option_32_Light.jpg",
		500,
		100
	],
	[
		"res://Lights/Light_option_13.jpg",
		"res://Lights/Light_option_13_Light.jpg",
		"res://Lights/Light_option_33.jpg",
		"res://Lights/Light_option_33_Light.jpg",
		100,
		300
	],
	[
		"res://Lights/Light_option_14.jpg",
		"res://Lights/Light_option_14_Light.jpg",
		"res://Lights/Light_option_34.jpg",
		"res://Lights/Light_option_34_Light.jpg",
		500,
		300
	]
]

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

func _create_lights():
	var light_button_group_scene = load("res://Lights/LightButtonGroup.tscn")
	
	for l in lights:
		var light_button_group: LightButtonGroup = light_button_group_scene.instance()
		
		light_button_group.set_lights(l[0], l[1], l[2], l[3], l[4], l[5])
		add_child(light_button_group)

func _ready():
	var window_size = OS.window_size

	_create_cars()
	_create_lights()
	
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
