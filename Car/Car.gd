extends KinematicBody2D

class_name Car

# this signal is emitted when the car leaves the route
signal car_exited(car, points)
signal game_over

enum {
	STRAIGHT_AHEAD,
	TURNING,
	TURNED
}

var playback: AudioStreamPlayback
var phase = 0.0
var engine_conf = null

# direction vectors
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

# constants for car control
const ACCELERATION := Globals.TILE_SIDE_LEN * 0.6
const MAX_SPEED := Globals.TILE_SIDE_LEN
const TURNING_SPEED_LEFT := Globals.TILE_SIDE_LEN * .9
const TURNING_SPEED_RIGHT := Globals.TILE_SIDE_LEN * .8
const FRICTION := Globals.TILE_SIDE_LEN * 0.6
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

var beeped = false

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

onready var sprite := $Sprite
onready var animationPlayer := $AnimationPlayer
onready var enginePlayer := $EngineAudioStreamPlayer

onready var carHorn1 := $CarHorn1
onready var carHorn2 := $CarHorn2

onready var carHorns = [carHorn1, carHorn2]

onready var honkTimer = $HonkTimer

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_reduce_point")

func _ready():
	$EngineAudioStreamPlayer.stream.mix_rate = Globals.SAMPLE_HZ
	playback = $EngineAudioStreamPlayer.get_stream_playback()
	_reset_car()

# called when the car should drive
func _go():
	drive = true
	timer.start()
	
	engine_conf = Globals.get_engine_conf()
	
	if engine_conf != null:
		enginePlayer.play()

func _reduce_point():
	points -= 1

	if points <= 0:
		emit_signal("game_over")

func setRoute(r):
	route = r
	ind = 0

# Determines the car's direction. Used when checking if the Car may enter a crossing
func movingInDirection():
	var dir
	if  getRoute().getTileAtInd(ind + 1) != null:
		dir = getRoute().getTileAtInd(ind + 1).positionFromTile(getRoute().getTileAtInd(ind))
	else:
		dir = getRoute().getTileAtInd(ind).positionFromTile(getRoute().getTileAtInd(ind - 1))
	return dir

func getRoute():
	return route

func _fill_audio_buffer():
	if engine_conf == null:
		return
		
	var increment = (engine_conf["baseHz"] + (velocity * .015).length() * engine_conf["hz"]) / Globals.SAMPLE_HZ
	
	var to_fill = playback.get_frames_available()
	
	while to_fill > 0:
		var vec = Vector2.ONE
		
		if phase < .25:
			vec *= (.25 - phase) / .25
		elif phase < .50:
			vec *= 1.0 - (.25 - phase) / .25
		elif phase < .75:
			vec *= -((.25 - phase) / .25)
		else:
			vec *= (.25 - phase) / .25 - 1
			
		playback.push_frame(vec)
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1

func _reset_car():
	turn_state = STRAIGHT_AHEAD

	sprite.texture = carTextures[randi() % carTextures.size()]
	
	velocity = Vector2.ZERO
	current_speed = MAX_SPEED
	speed_modifier = ACCELERATION
	drive = false

	points = MAX_POINTS

	timer.stop()

	self.position = Globals.VARIKKO # Car is initially spawned in a space outside the map

	animationPlayer.play("DriveStraight")

func _make_a_turn(turnDirection):
	match turnDirection:
		Globals.RIGHT:
			current_speed = TURNING_SPEED_RIGHT
			input_vector = input_vector.rotated(PI / 2)

		Globals.LEFT:
			current_speed = TURNING_SPEED_LEFT
			input_vector = input_vector.rotated(3 * PI / 2)

		_:
			current_speed = MAX_SPEED

	speed_modifier = FRICTION
	turn_state = TURNING

# Primary movement. Checks the Tiles on the Route to see whether to move or stop
func _set_speed_and_direction(delta):
	var tile = route.getTileAtInd(ind)
	var nextTile = route.getTileAtInd(ind + 1)
	var nextTurn = route.getNextTurnAtInd(ind)

	match nextTurn:
		Globals.STRAIGHT:
			animationPlayer.play("DriveStraight")
		Globals.LEFT:
			animationPlayer.play("TurnLeft")
		Globals.RIGHT:
			animationPlayer.play("TurnRight")

	if route.isTurningAtInd(ind):
		_make_a_turn(nextTurn)
	else:
		_make_a_turn(Globals.STRAIGHT)

	# If the Route ends, Car exits and resets
	if nextTile == null:
		if tile != null:
			tile.takingCar = null
		emit_signal("car_exited", self, points)
		if enginePlayer.playing:
			enginePlayer.stop()
			Globals.car_engines_on -= 1
		_reset_car()
	# If the next Tile on the Route is available (has no other Car on it and traffic lights allow passage to it)
	# then the Car will move onto it, marking it as taken by itself if it is in a crossing
	# to prevent other Cars from entering it simultaneously.
	elif (nextTile.takingCar == self or nextTile.isFree()) and nextTile.mayEnter(movingInDirection()):
		var next_nextTile = route.getTileAtInd(ind + 2)
		if (nextTile.is_crossing and next_nextTile.is_crossing and next_nextTile.takingCar == null) or not nextTile.is_crossing or not next_nextTile.is_crossing:
			if nextTile.takingCar == null:
				nextTile.takingCar = self
			speed_modifier = ACCELERATION
			input_vector = position.direction_to(nextTile.global_position).normalized()
	# The Car will always move onto a tile it has previously marked as taken
	elif nextTile.takingCar == self:
		speed_modifier = ACCELERATION
		input_vector = position.direction_to(nextTile.global_position).normalized()
	# If the traffic lights are changed when the Car is still in the crossing,
	# the Car will continue moving out of the way and mark the next Tile as taken
	# so that deadlocks do not occur
	elif tile.is_crossing and nextTile.isFree() and nextTile.is_crossing and not nextTile.mayEnter(movingInDirection()):
		if nextTile.takingCar == null:
			nextTile.takingCar = self
		speed_modifier = ACCELERATION
		input_vector = position.direction_to(nextTile.global_position).normalized()
	# In the case that the Car may not move onto the next Tile,
	# then it will stop, and if it had marked the next Tile as taken, unmark it to free it for others
	else:
		if nextTile.takingCar == self:
			nextTile.takingCar = null
		speed_modifier = FRICTION
		input_vector = Vector2.ZERO

func _move(delta):
	velocity = velocity.move_toward(input_vector * current_speed, speed_modifier * delta)
	velocity = move_and_slide(velocity)

func _rotate():
	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle

func _physics_process(delta):
	_fill_audio_buffer()
	
	if not drive or not route:
		velocity = Vector2.ZERO
		return

	if drive and velocity == Vector2.ZERO and input_vector == Vector2.ZERO and not beeped:
		beeped = true
		honkTimer.start(2.0)
	elif drive and velocity != Vector2.ZERO:
		beeped = false
		honkTimer.stop()

	_set_speed_and_direction(delta)

	_move(delta)

	if velocity != Vector2.ZERO:
		_rotate()


func _on_HonkTimer_timeout():
	carHorns.shuffle()
	carHorns[0].play()
