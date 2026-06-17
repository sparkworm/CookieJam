class_name BloodPool
extends Node2D

## The maximum scaling of the current scale allowed
@export var max_scale: float = 2.0
@export var max_scale_variation: float = 0.5
## The time spent "spreading" to reach full size
@export var expansion_time: float = 2
@export var expansion_time_variation: float = 1

func _ready() -> void:
	var final_scale: float = max_scale + randf_range(-1, 1) * max_scale_variation
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(final_scale, final_scale), 
			expansion_time + randf_range(-1, 1) * expansion_time_variation)
