## Look around, waiting to see or hear player.
## [br]Changes to: 
## [br] - Investigating: Sound heard
## [br] - Approaching: Player seen
class_name ScanningState
extends State

@export var investigating_state: InvestigatingState
@export var approaching_state: ApproachingState

## Component for detecting the player.  We will want to connect to its detection signals, but we
## MUST remember to disconnect in _exit_state()
@export var detection_component: DetectionComponent

func _enter_state(_args: Dictionary[String,Variant]) -> void:
	detection_component.target_spotted.connect(player_spotted)

func _exit_state() -> void:
	detection_component.target_spotted.disconnect(player_spotted)

## The player has entered the Vision cone and we have LOS: change to approach state
func player_spotted(player: Node2D) -> void:
	var dict: Dictionary[String,Variant] = {"target":player}
	state_changed.emit(approaching_state, dict)
