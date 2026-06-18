## Player in LOS and range: attack
## [br]Changes to: 
## [br]- Investigating: Player leaves LOS
## [br]- Approaching: Player leaves range
class_name AttackingState
extends State


@export var investigating_state: InvestigatingState
@export var approaching_state: ApproachingState
@export var scanning_state: ScanningState

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
	if character.active_weapon.full_auto:
		character.active_weapon.pull_trigger()

func _exit_state() -> void:
	character.active_weapon.release_trigger()

func _physics_update(_delta: float) -> void:
	# if the player has died, simply return to scanning
	if target == null or not is_instance_valid(target):
		var dict: Dictionary[String,Variant]
		state_changed.emit(scanning_state, dict)
		return
	# if LOS is lost, change to investigating
	if not detection_component.has_los(target):
		var dict: Dictionary[String,Variant] = {"target":target.position}
		state_changed.emit(investigating_state, dict)
	# if the player is out of range, resume approaching
	if character.global_position.distance_to(target.global_position) > disengagement_range:
		var dict: Dictionary[String,Variant] = {"target":target}
		state_changed.emit(approaching_state, dict)
		return
	
	# face player
	character.look_at(target.global_position)
	
	if character.active_weapon.ammo == 0:
		character.active_weapon.reload()
	
	# firing logic
	if not character.active_weapon.full_auto:
		character.active_weapon.pull_trigger()
		character.active_weapon.release_trigger()
	
