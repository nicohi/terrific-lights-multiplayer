extends KinematicBody2D

class_name Car

# this signal is emitted when the car leaves the route
signal car_exited(car, points)
signal game_over(car)

# constants for car control
const ACCELERATION := Globals.TILE_SIDE_LEN * 0.6
const MAX_SPEED := Globals.TILE_SIDE_LEN
const TURNING_SPEED_LEFT := Globals.TILE_SIDE_LEN * .9
const TURNING_SPEED_RIGHT := Globals.TILE_SIDE_LEN * .8
const FRICTION := Globals.TILE_SIDE_LEN * 0.6

var velocity := Vector2.ZERO # current car velocity
var input_vector := Vector2.ZERO # current direction of the car
var current_speed := MAX_SPEED
var speed_modifier := ACCELERATION
var drive := false # if true, the car can proceed

var route setget setRoute
var proceed setget setProgress
var ind: int

onready var sprite := $Sprite
onready var animationPlayer := $AnimationPlayer

# Hands out random textures for the cars.
onready var texturizer := $Texturizer

# Handles the car horn functionality.
onready var honkabilly := $Honkabilly

# Keeps track of the points that the car has left.
onready var pointCounter := $PointCounter

# Handles the cars' engine sounds.
onready var engineer := $Engineer

func _ready():
	pointCounter.connect("zero_points", self, "_game_over")
	_reset_car()

func _game_over():
	emit_signal("game_over", self)

# Called when the car should start driving.
func _go():
	drive = true
	pointCounter.start()
	
	engineer.play()

# Set the car's route and reset to the beginning of the route.
func setRoute(r):
	route = r
	ind = 0

func setProgress(p):
	proceed = p

# Determines the car's direction. Used when checking if the Car may enter a crossing
func movingInDirection():
	var dir
	if  route.getTileAtInd(ind + 1) != null:
		dir = route.getTileAtInd(ind + 1).positionFromTile(route.getTileAtInd(ind))
	else:
		dir = route.getTileAtInd(ind).positionFromTile(route.getTileAtInd(ind - 1))
	return dir

# When the car is reset, it will
#   1. get a random texture for its sprite and
#   2. be stopped entirely and prohibited from moving.
func _reset_car():
	sprite.texture = texturizer.get_texture()
	
	velocity = Vector2.ZERO
	current_speed = MAX_SPEED
	speed_modifier = ACCELERATION
	drive = false
	proceed = 2

	pointCounter.reset()
	pointCounter.stop()

	self.position = Globals.VARIKKO # Car is initially spawned in a space outside the map

	animationPlayer.play("DriveStraight")

# When the car is turned,
#   1. its turning speed is adjusted based on the direction it is turning and
#   2. it is rotated.
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

# Resolve and set the appropriate animation based on the forthcoming turn.
func _resolve_animation(nextTurn):
	match nextTurn:
		Globals.STRAIGHT:
			animationPlayer.play("DriveStraight")
		Globals.LEFT:
			animationPlayer.play("TurnLeft")
		Globals.RIGHT:
			animationPlayer.play("TurnRight")

# Resolve where to turn (or whether to continue straight ahead).
func _resolve_turn(nextTurn):
	if route.isTurningAtInd(ind):
		_make_a_turn(nextTurn)
	else:
		_make_a_turn(Globals.STRAIGHT)

# The car has come to the end of its route.
func _finish_run(tile):
	if tile != null:
		tile.takingCar = null

	emit_signal("car_exited", self, pointCounter.points)
	engineer.stop()
	_reset_car()

func _car_may_proceed_to(nextTile):
	return (
		(nextTile.takingCar == self or nextTile.isFree()) and
		nextTile.mayEnter(movingInDirection())
	)

func _car_will_proceed_to_crossing(nextTile):
	var next_nextTile = route.getTileAtInd(ind + 2)
	
	return (
		(
			nextTile.is_crossing and
			next_nextTile.is_crossing and
			next_nextTile.takingCar == null
		) or
		not nextTile.is_crossing or
		not next_nextTile.is_crossing
	)

func _car_is_still_in_the_crossing(tile, nextTile):
	return (
		tile.is_crossing and
		nextTile.isFree() and
		nextTile.is_crossing and
		not nextTile.mayEnter(movingInDirection())
	)

func _go_to_next_tile(nextTile):
	speed_modifier = ACCELERATION
	input_vector = position.direction_to(nextTile.global_position).normalized()

# Primary movement. Checks the Tiles on the Route to see whether to move or stop
func _set_speed_and_direction(delta):
	var tile = route.getTileAtInd(ind)
	var nextTile = route.getTileAtInd(ind + 1)
	var nextTurn = route.getNextTurnAtInd(ind)

	_resolve_animation(nextTurn)

	_resolve_turn(nextTurn)

	# If the Route ends, Car exits and resets
	if nextTile == null:
		_finish_run(tile)
		
	# If the next Tile on the Route is available (has no other Car on it and traffic lights allow passage to it)
	# then the Car will move onto it, marking it as taken by itself if it is in a crossing
	# to prevent other Cars from entering it simultaneously.
	elif _car_may_proceed_to(nextTile) and _car_will_proceed_to_crossing(nextTile):
		if nextTile.takingCar == null:
			nextTile.takingCar = self
		
		_go_to_next_tile(nextTile)
			
	# The Car will always move onto a tile it has previously marked as taken
	elif nextTile.takingCar == self:
		_go_to_next_tile(nextTile)
	
	# If the traffic lights are changed when the Car is still in the crossing,
	# the Car will continue moving out of the way and mark the next Tile as taken
	# so that deadlocks do not occur
	elif _car_is_still_in_the_crossing(tile, nextTile):
		if nextTile.takingCar == null:
			nextTile.takingCar = self
		
		_go_to_next_tile(nextTile)
		
	# In the case that the Car may not move onto the next Tile,
	# then it will stop, and if it had marked the next Tile as taken, unmark it to free it for others
	else:
		if nextTile.takingCar == self:
			nextTile.takingCar = null
		
		speed_modifier = FRICTION
		input_vector = Vector2.ZERO

# Move the car towards the input_vector using the current speed_modifier.
func _move(delta):
	velocity = velocity.move_toward(input_vector * current_speed, speed_modifier * delta)
	velocity = move_and_slide(velocity)

# Rotates the car to the direction it is heading to.
func _rotate():
	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle

func _physics_process(delta):
	if not drive or not route:
		velocity = Vector2.ZERO
		return

	if (
		drive and
		velocity == Vector2.ZERO and
		input_vector == Vector2.ZERO
	):
		honkabilly.honk()
	elif drive and velocity != Vector2.ZERO:
		honkabilly.cancel_honk()

	_set_speed_and_direction(delta)

	_move(delta)

	engineer.velocity = velocity
	
	if velocity != Vector2.ZERO:
		_rotate()
