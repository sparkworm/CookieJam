class_name Player
extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent

func _physics_process(delta: float) -> void:
	# point towards mouse
	look_at(get_global_mouse_position())
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir != Vector2.ZERO:
		velocity_component.accelerate(delta, move_dir)
	else:
		velocity_component.resolve_decel(delta)
	velocity = velocity_component.velocity
	move_and_slide()
	# potentially reduce velocity component's velocity if we hit a wall
	velocity_component.velocity = velocity
