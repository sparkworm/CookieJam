## Player in LOS and range: attack
## [br]Changes to: 
## [br]- Investigating: Player leaves LOS
## [br]- Approaching: Player leaves range
class_name AttackingState
extends State


@export var investigating_state: InvestigatingState
@export var approaching_state: ApproachingState

## Component for detecting the player.  We will want to connect to its detection signals, but we
## MUST remember to disconnect in _exit_state()
@export var detection_component: DetectionComponent
@export var character: Enemy
## The distance from the player at which point this enemy will try to close the distance again.
## This should actually be greater than engagement_range in ApproachingState so that there is a 
## little buffer.
@export var disengagement_range: float

var target: Player

func _enter_state(args: Dictionary[String,Variant]) -> void:
	target = args["target"]
