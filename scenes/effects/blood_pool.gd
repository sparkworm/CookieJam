class_name BloodPool
extends Node2D

## The maximum scaling of the current scale allowed
@export var max_scale: float = 2.0
@export var max_scale_variation: float = 0.5
## The time spent "spreading" to reach full size
@export var expansion_time: float = 2.0
@export var expansion_time_variation: float = 1.0

## As it stands, there is currently no randomness in the time taken for blood to darken
@export var darken_time: float = 30.0
@export var final_color: Color = Color(0.451, 0.125, 0.043, 1.0)

func _ready() -> void:
	var final_scale: float = (max_scale + randf_range(-1, 1) * max_scale_variation)
	# compensate for starting scale
	final_scale *= scale.length()
	var expansion_tween: Tween = get_tree().create_tween()
	expansion_tween.tween_property(self, "scale", Vector2(final_scale, final_scale), 
			expansion_time + randf_range(-1, 1) * expansion_time_variation)
	
	var darken_tween: Tween = get_tree().create_tween()
	darken_tween.tween_property(self, "modulate", final_color, darken_time)
	
