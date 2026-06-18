## Class that can check for vision detection and LOS, as well as sound detection
## TODO: sound detection
class_name DetectionComponent
extends Node2D

signal target_spotted(target: Node2D)

@export var vision_detect: Area2D
@export var los_check: RayCast2D
@export var target_group: String

func _ready() -> void:
	vision_detect.body_entered.connect(body_entered_vision_detect)

func body_entered_vision_detect(body: Node2D) -> void:
	if not body.is_in_group(target_group):
		# given the masks I will use, I don't expect this ever SHOULD occur, so I'm keeping the
		# print statement.  If this is printed, something is WRONG.
		print("body not in group")
		return
	if has_los(body):
		target_spotted.emit(body)

func has_los(body: Node2D) -> bool:
	los_check.global_rotation = 0.0
	los_check.target_position = body.global_position - global_position
	los_check.force_raycast_update()
	return los_check.get_collider() == body
