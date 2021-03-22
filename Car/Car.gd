extends KinematicBody2D

class_name Car

var velocity = Vector2.ZERO
var factor = 1
var rotation_factor = 1

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if self.position.y <= 0:
		factor = 1
	elif self.position.y > 300:
		factor = -1
	
	if self.rotation_degrees >= 90:
		rotation_factor = -1
	elif self.rotation_degrees <= 0:
		rotation_factor = 1
		
	self.rotate(rotation_factor * .05)
	
	velocity.y = .5 * factor
		
	move_and_collide(velocity)
