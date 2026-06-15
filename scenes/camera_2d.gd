class_name Camera
extends Camera2D

## Controls the amount that the moust pointer "pulls" the camera
@export var look_strength: float = 0.1
@export var subject: Node2D

func _process(_delta: float) -> void:
	# update position to match the target
	follow_subject()
	# apply offset from mouse pointer
	apply_offset()

## Updates position to match that of the subject
func follow_subject() -> void:
	if subject != null:
		global_position = subject.global_position

## Updates offset to be offset from the center of the screen by some multiple of the vector to the
## mouse pointer
func apply_offset() -> void:
	offset = look_strength * (get_global_mouse_position()-get_screen_center_position())
