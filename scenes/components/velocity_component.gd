## Responsible for some basic functionality regarding the manipulation of velocity
class_name VelocityComponent
extends Node


## Hard cap on the magnitude of velocity
@export var max_speed: float
## The assumed accel of the object used in accel()
@export var accel: float
## A flat decceleration meant to be applied every frame
@export var decel: float

var velocity: Vector2

## Reduces the magnitude of the velocity linearly by decel
func resolve_decel(delta: float) -> void:
	var new_mag: float = max(0,velocity.length() - decel * delta)
	velocity = velocity.normalized() * new_mag

## Adds direction * magnitude to the velocity.  If the magnitude of the new velocity exceeds
## max_speed, the magnitude is set to max_speed.  Magnitude will default to accel, as that is the 
## intended behavior, but a custom magnitude can technically be specified
func accelerate(delta: float, direction: Vector2, magnitude: float = accel) -> void:
	velocity += direction * magnitude * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

func set_velocity(vel: Vector2) -> void:
	velocity = vel
