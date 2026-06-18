## Class for handling characters, including the player and enemies
## Characters have the following traits:
## [br]Characters may weild a weapon (only one at a time)
class_name Character
extends CharacterBody2D

const BLOOD_POOL_DT = preload("uid://270mt62wcar")


@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent
@export var active_weapon: Weapon

@export var blood_pools: int = 3
@export var blood_pools_variation: int = 1

var alive: bool = true

func _ready() -> void:
	health_component.health_depleted.connect(die)

## Gets current velocity from velocity component, then moves appropriately, finally updating
## velocity in case of collision.
func apply_velocity() -> void:
	velocity = velocity_component.velocity
	move_and_slide()
	# potentially reduce velocity component's velocity if we hit a wall
	velocity_component.velocity = velocity

## TODO: add dead body
func die() -> void:
	if not alive:
		return
	alive = false
	print("dying")
	var to_spawn: int = blood_pools + randi_range(-blood_pools_variation, blood_pools_variation)
	while to_spawn > 0:
		var pool: DecalTransport = BLOOD_POOL_DT.instantiate()
		MessageBus.decal_transport_spawned.emit(global_position, 0.0, pool)
		to_spawn -= 1
	queue_free()

## ASSUME: incoming damage is a positive value
## TODO: add blood splatter
func take_hit(damage: int) -> void:
	health_component.change_health(-damage)
	print(health_component.health)

## Pull the active weapon's trigger
func pull_trigger() -> void:
	active_weapon.pull_trigger()

## Release the active weapon's trigger
func release_trigger() -> void:
	active_weapon.release_trigger()

func reload() -> void:
	active_weapon.reload()
