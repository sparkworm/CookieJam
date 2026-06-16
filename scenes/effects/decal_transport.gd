## Somewhat convoluted manner of placing decals.  Basically, this decal transport moves with a 
## specified velocity and speed until it slows to a stop.  Then it emits a signal to reparent the
## actual decal so that the character body can be freed.
## [br] it is worth noting that this is based on when the LINEAR velocity reaches 0.  If this
## happens before rotational velocity reaches 0, spinning will stop abruptly.  
class_name DecalTransport
extends CharacterBody2D

@export var decal: Node2D

## Rotational velocity entered in degrees per second
@export var spin_speed: float
@export var spin_speed_variation: float
@export var spin_decel: float
## Starting velocity in pixels per second
@export var launch_speed: float
@export var launch_speed_variation: float
@export var launch_angle_variation: float
@export var linear_decel: float

var rotational_velocity: float
var transport_active: bool

func initialize(pos: Vector2, rot: float) -> void:
	transport_active = true
	global_position = pos
	if decal == null:
		push_warning("no decal in decal transport: aborting")
		queue_free()
		return
	var angle: Vector2 = Vector2.from_angle(rot 
			+ randf_range(-launch_angle_variation, launch_angle_variation))
	velocity = angle * (launch_speed + randf_range(-launch_speed_variation, launch_speed_variation))
	rotational_velocity = spin_speed + randf_range(-spin_speed_variation, spin_speed_variation)

func _physics_process(delta: float) -> void:
	if not transport_active:
		print("transport stopped")
		return
	if velocity == Vector2.ZERO:
		end_transport()
	move_and_slide()
	var speed: float = velocity.length()
	speed = max(0, speed - delta * linear_decel)
	# probably not the most efficient way to do all this
	velocity = velocity.normalized() * speed
	
	decal.rotation += rotational_velocity * delta
	rotational_velocity = max(0, rotational_velocity - spin_decel * delta)

## Deposite the decal as a sprite, then remove the DecalTransport to save on performance
func end_transport() -> void:
	transport_active = false
	decal.reparent(get_parent(), true)
	queue_free()
