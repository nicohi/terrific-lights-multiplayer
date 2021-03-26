extends KinematicBody2D

class_name Car

# this signal is emitted when the car goes out of view
signal car_exited(car)

# direction vectors
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

# constants for car control
const ACCELERATION := 100
const MAX_SPEED := 200
const TURNING_SPEED := 75
const FRICTION := 100
const DIRECTIONS := [LEFT, RIGHT, UP]
const PADDING := 50
const START_DIR := UP

var velocity := Vector2.ZERO # current car velocity
var input_vector := START_DIR # current direction of the car
var direction := Vector2.ZERO # the direction to turn to
var current_speed := MAX_SPEED
var speed_modifier := ACCELERATION
var turn_done := false # true when the turn is complete
var drive := false # if true, the car can proceed

onready var start_pos := Vector2(
	OS.window_size.x / 2,
	OS.window_size.y + PADDING
)
onready var sprite := $Sprite

func _ready():
	_reset_car()

# called when the car should drive
func _go():
	drive = true

# get a random direction to turn to
func _get_direction() -> Vector2:
	return DIRECTIONS[randi() % DIRECTIONS.size()]

# resets the car to be ready to head for a new adventure
func _reset_car():
	self.position = start_pos
	input_vector = START_DIR
	velocity = Vector2.ZERO
	direction = _get_direction()
	current_speed = MAX_SPEED
	speed_modifier = ACCELERATION
	turn_done = false
	drive = false

# returns true if the car is out of the screens view
func _out_of_view() -> bool:
	var window_size = OS.window_size
	
	return (
		self.position.y < -PADDING or
		self.position.y > window_size.y + PADDING or
		self.position.x < -PADDING or
		self.position.x > window_size.x + PADDING
	)

func _set_speed_and_direction():
	if self.position.y <= 2 * OS.window_size.y / 3 and direction != DIRECTIONS[2]:
		current_speed = TURNING_SPEED
		speed_modifier = FRICTION
	
	if turn_done:
		current_speed = MAX_SPEED
		speed_modifier = ACCELERATION
		
	if self.position.y <= OS.window_size.y / 2:
		input_vector = direction

func _move(delta):
	velocity = velocity.move_toward(input_vector * current_speed, speed_modifier * delta)
	
	velocity = move_and_slide(velocity)

func _rotate():
	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle
	
	if (
		stepify(self.rotation, .01) == stepify(PI / 2, .01) or
		stepify(self.rotation, .01) == stepify(3 * PI / 2, .01)
	):
		turn_done = true

func _physics_process(delta):
	if not drive:
		# stand still
		velocity = Vector2.ZERO
		return

	if _out_of_view():
		emit_signal("car_exited", self)
		_reset_car()

	_set_speed_and_direction()
	
	_move(delta)
	_rotate()

