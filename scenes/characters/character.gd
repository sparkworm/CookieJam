## Class for handling characters, including the player and enemies
## Characters have the following traits:
## [br]Characters may weild a weapon (only one at a time)
class_name Character
extends CharacterBody2D

@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent
@export var active_weapon: Weapon

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
	queue_free()

## ASSUME: incoming damage is a positive value
## TODO: add blood splatter
func take_hit(damage: int) -> void:
	
	health_component.change_health(-damage)

## Pull the active weapon's trigger
func pull_trigger() -> void:
	active_weapon.pull_trigger()

## Release the active weapon's trigger
func release_trigger() -> void:
	active_weapon.release_trigger()

func reload() -> void:
	active_weapon.reload()
