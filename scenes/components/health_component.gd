## Component for keeping track of health for any killable character.
## May eventually support functionality for regeneration
class_name HealthComponent
extends Node

signal health_depleted()

@export var max_health: int = 100

var health: int

func _ready() -> void:
	health = max_health

func change_health(amnt: int) -> void:
	health = clamp(health + amnt, 0, max_health)
	if health == 0:
		health_depleted.emit()
