extends KinematicBody2D

class_name Car

# this signal is emitted when the car goes out of view
signal car_exited(car, points)
signal game_over

enum {
	STRAIGHT_AHEAD,
	TURNING,
	TURNED
}

# direction vectors
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

# constants for car control
const ACCELERATION := Globals.TILE_SIDE_LEN / 2
const MAX_SPEED := Globals.TILE_SIDE_LEN
const TURNING_SPEED_LEFT := Globals.TILE_SIDE_LEN * .875
const TURNING_SPEED_RIGHT := Globals.TILE_SIDE_LEN * .625
const FRICTION := Globals.TILE_SIDE_LEN / 2
const DIRECTIONS := [LEFT, RIGHT, UP]
const START_DIR := UP
const MAX_POINTS := 99

var velocity := Vector2.ZERO # current car velocity
var input_vector := START_DIR # current direction of the car
var direction := Vector2.ZERO # the direction to turn to
var current_speed := MAX_SPEED
var speed_modifier := ACCELERATION
var drive := false # if true, the car can proceed
var points := MAX_POINTS
var turn_state := STRAIGHT_AHEAD

var timer: Timer

var route setget setRoute, getRoute
var ind: int

var blackCar = preload("res://Car/TriotemplateBlackTurns.png")
var blueCar = preload("res://Car/TriotemplateBlueTurns.png")
var redCar = preload("res://Car/TriotemplateRedTurn.png")
var tanCar = preload("res://Car/TriotemplateTanTurns.png")
var greenCar = preload("res://Car/TriotemplateGreenTurns.png")
var orangeCar = preload("res://Car/TriotemplateOrangeTurns.png")
var purpleCar = preload("res://Car/TriotemplatePurpleTurns.png")
var tealCar = preload("res://Car/TriotemplateTealTurns.png")
var whiteCar1 = preload("res://Car/TriotemplateWhite1Turns.png")
var whiteCar2 = preload("res://Car/TriotemplateWhite2Turns.png")

var carTextures = [
	blackCar,
	blueCar,
	redCar,
	tanCar,
	greenCar,
	orangeCar,
	purpleCar,
	tealCar,
	whiteCar1,
	whiteCar2
]

onready var zero_corner := get_viewport_rect().size / 2 - Vector2(540, 540)
onready var start_pos_nwn := zero_corner + Vector2(8 * Globals.TILE_SIDE_LEN, 0)
onready var start_pos_nww := zero_corner + Vector2(0, 9 * Globals.TILE_SIDE_LEN)
onready var start_pos_nen := zero_corner + Vector2(18 * Globals.TILE_SIDE_LEN, 0)
onready var start_pos_nee := zero_corner + Vector2(27 * Globals.TILE_SIDE_LEN, 8 * Globals.TILE_SIDE_LEN)
onready var start_pos_sww := zero_corner + Vector2(0, 19 * Globals.TILE_SIDE_LEN)
onready var start_pos_sws := zero_corner + Vector2(9 * Globals.TILE_SIDE_LEN, 27 * Globals.TILE_SIDE_LEN)
onready var start_pos_ses := zero_corner + Vector2(19 * Globals.TILE_SIDE_LEN, 27 * Globals.TILE_SIDE_LEN)
onready var start_pos_see := zero_corner + Vector2(27 * Globals.TILE_SIDE_LEN, 18 * Globals.TILE_SIDE_LEN)

onready var south_facing_start_positions = [start_pos_nwn, start_pos_nen]
onready var east_facing_start_positions = [start_pos_nww, start_pos_sww]
onready var north_facing_start_positions = [start_pos_ses, start_pos_sws]
onready var west_facing_start_positions = [start_pos_nee, start_pos_see]

onready var start_positions = [
	start_pos_nwn,
	start_pos_nww,
	start_pos_nen,
	start_pos_nee,
	start_pos_see,
	start_pos_ses,
	start_pos_sws,
	start_pos_sww
]

onready var sprite := $Sprite
onready var animationPlayer := $AnimationPlayer

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_reduce_point")

func _ready():
	randomize()
	_reset_car()

# called when the car should drive
func _go():
	drive = true
	timer.start()

func _reduce_point():
	points -= 1
	
	if points <= 0:
		emit_signal("game_over")

# get a random direction to turn to
#func _get_direction() -> Vector2:
#	return DIRECTIONS[randi() % DIRECTIONS.size()]
#
#func _get_start_direction() -> Vector2:
#	if south_facing_start_positions.has(self.position):
#		return DOWN
#	elif east_facing_start_positions.has(self.position):
#		return RIGHT
#	elif north_facing_start_positions.has(self.position):
#		return UP
#	else:
#		return LEFT
		
func setRoute(r: Route):
	route = r
	ind = -1
	self.position = route.getTileAtInd(0).position
	
func getRoute():
	return route
	
# resets the car to be ready to head for a new adventure
func _reset_car():
	turn_state = STRAIGHT_AHEAD
	
	sprite.texture = carTextures[randi() % carTextures.size()]
	
#	self.position = start_positions[randi() % start_positions.size()]
	
#	self.input_vector = _get_start_direction()

	
	velocity = Vector2.ZERO
	
#	direction = _get_direction()
	
	current_speed = MAX_SPEED
	speed_modifier = ACCELERATION
	
	drive = false
	
	points = MAX_POINTS
	
	timer.stop()
	
	animationPlayer.play("DriveStraight")

# returns true if the car is out of the screens view
func _out_of_view() -> bool:
	var window_size = get_viewport_rect().size
	
	return (
		self.position.y < -5 or
		self.position.y > 540 * 2 + 5 or
		self.position.x < zero_corner.x - 5 or
		self.position.x > zero_corner.x + 540 * 2 + 5
	)

func _make_a_turn():
	match direction:
		RIGHT:
			animationPlayer.play("TurnRight")
			current_speed = TURNING_SPEED_RIGHT
			input_vector = input_vector.rotated(PI / 2)
			
		LEFT:
			animationPlayer.play("TurnLeft")
			current_speed = TURNING_SPEED_LEFT
			input_vector = input_vector.rotated(3 * PI / 2)
			
		_:
			animationPlayer.play("DriveStraight")
			current_speed = MAX_SPEED
			
	speed_modifier = FRICTION
	turn_state = TURNING

func _finish_turning():
	animationPlayer.play("DriveStraight")

	current_speed = MAX_SPEED
	speed_modifier = ACCELERATION

	turn_state = STRAIGHT_AHEAD
#	direction = _get_direction()

func _set_speed_and_direction(delta):
#	match turn_state:
#		STRAIGHT_AHEAD:
#			if randf() < .002:
#				_make_a_turn()
#
#		TURNING:
#			if velocity.normalized() == input_vector:
#				turn_state = TURNED
#
#		TURNED:
#			_finish_turning()
	var nextTile = route.getTileAtInd(ind + 1)
	if nextTile == null:
		emit_signal("car_exited", self, points)
		_reset_car()
	elif not nextTile.isFree():
		input_vector = Vector2.ZERO
	else:
		input_vector = position.direction_to(nextTile.global_position).normalized()

func _move(delta):
	velocity = velocity.move_toward(input_vector * current_speed, speed_modifier * delta)
	
	velocity = move_and_slide(velocity)

func _rotate():
	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle

func _physics_process(delta):
	if not drive or not route:
		# stand still
		velocity = Vector2.ZERO
		return

	if _out_of_view():
		emit_signal("car_exited", self, points)
		_reset_car()

	_set_speed_and_direction(delta)
	
	_move(delta)
	_rotate()

