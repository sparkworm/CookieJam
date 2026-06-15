class_name Player
extends Character

@export var available_weapons: Array[Weapon]

var active_weapon_idx: int

func _ready() -> void:
	# hardcoded for 2 weapons
	# ASSUME: there are two weapon in available weapons, and active_weapon is one of them
	active_weapon_idx = 0 if active_weapon == available_weapons[0] else 1

func _physics_process(delta: float) -> void:
	# point towards mouse
	look_at(get_global_mouse_position())
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir != Vector2.ZERO:
		velocity_component.accelerate(delta, move_dir)
	else:
		velocity_component.resolve_decel(delta)
	apply_velocity()
	
	if Input.is_action_just_pressed("fire_weapon"):
		pull_trigger()
	if Input.is_action_just_released("fire_weapon"):
		release_trigger()
	if Input.is_action_just_pressed("reload"):
		reload()
	if Input.is_action_just_pressed("switch_weapon"):
		switch_active_weapon()

## Switches through the array available_weapons.
## Technically, this function can support any nonzero number of weapons, but the player can have one
## of two weapons, the shotgun and the rifle.
func switch_active_weapon() -> void:
	active_weapon.hide()
	# switch between 0 or 1
	active_weapon_idx = (active_weapon_idx + 1) % available_weapons.size()
	active_weapon = available_weapons[active_weapon_idx]
	active_weapon.show()
