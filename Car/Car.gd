extends KinematicBody2D

class_name Car

const ACCELERATION := 200
const MAX_SPEED := 200
const FRICTION := 200
const DIRECTIONS := [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1)]
const PADDING := 50
const START_DIR := DIRECTIONS[2]

var velocity := Vector2.ZERO
var input_vector := START_DIR
var direction := Vector2()
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
	
	if self.position.y <= OS.window_size.y / 2:
		input_vector = direction
	
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	velocity = move_and_slide(velocity)

	var target_angle := atan2(velocity.x, velocity.y) - PI
	self.rotation = -target_angle
