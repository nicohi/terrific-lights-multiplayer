extends KinematicBody2D

class_name Car

const ACCELERATION := 300
const MAX_SPEED := 500
const TURNING_SPEED := 100
const FRICTION := 300
const DIRECTIONS := [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1)]
const PADDING := 50
const START_DIR := DIRECTIONS[2]

var velocity := Vector2.ZERO
var input_vector := START_DIR
var direction := Vector2()
var use_speed := MAX_SPEED
var use_factor := ACCELERATION
var turn_done := false

onready var start_pos := Vector2(
	OS.window_size.x / 2,
	OS.window_size.y + PADDING
)
onready var sprite := $Sprite

func _ready():
	_reset_car()

func _get_direction() -> Vector2:
	return DIRECTIONS[randi() % DIRECTIONS.size()]

func _reset_car():
	self.position = start_pos
	input_vector = START_DIR
	velocity = Vector2.ZERO
	direction = _get_direction()
	use_speed = MAX_SPEED
	use_factor = ACCELERATION
	turn_done = false

func _out_of_view() -> bool:
	var window_size = OS.window_size
	
	return (
		self.position.y < -PADDING
		or self.position.y > window_size.y + PADDING
		or self.position.x < -PADDING
		or self.position.x > window_size.x + PADDING
	)

func _physics_process(delta):
	if _out_of_view():
		_reset_car()
	
	if self.position.y <= 2 * OS.window_size.y / 3 and direction != DIRECTIONS[2]:
		use_speed = TURNING_SPEED
		use_factor = FRICTION
	
	if turn_done:
		use_speed = MAX_SPEED
		use_factor = ACCELERATION
	
	if self.position.y <= OS.window_size.y / 2:
		input_vector = direction
	
	velocity = velocity.move_toward(input_vector * use_speed, use_factor * delta)
	
	velocity = move_and_slide(velocity)

	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle
	
	if stepify(self.rotation, .01) == stepify(PI / 2, .01) or stepify(self.rotation, .01) == stepify(3 * PI / 2, .01):
		turn_done = true

