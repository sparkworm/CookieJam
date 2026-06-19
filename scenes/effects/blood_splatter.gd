class_name BloodSplatter
extends Sprite2D

## As it stands, there is currently no randomness in the time taken for blood to darken
@export var darken_time: float = 30.0
@export var final_color: Color = Color(0.451, 0.125, 0.043, 1.0)

func _ready() -> void:
	# pick random decal
	frame_coords.x = randi_range(0, hframes-1)
	
	var darken_tween: Tween = get_tree().create_tween()
	darken_tween.tween_property(self, "modulate", final_color, darken_time)
