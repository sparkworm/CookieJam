## Player in LOS: close the distance then switch to attack
## [br]Changes to: 
## [br] - Attacking: player in range
## [br] - Investigating: player leaves LOS
class_name ApproachingState
extends State

@export var attacking_state: AttackingState
@export var investigating_state: InvestigatingState

## Component for detecting the player.  We will want to connect to its detection signals, but we
## MUST remember to disconnect in _exit_state()
@export var detection_component: DetectionComponent
@export var nav_agent: NavigationAgent2D
@export var nav_timer: Timer
@export var character: Enemy

## The range from the player at which this enemy will switch to attacking
@export var engagement_range: float = 500
## The speed at which the enemy will approach along its path to reach the player.
## I imagine this would look better being higher than the investigate_speed in InvestigatingState.
@export var approach_speed: float = 500
@export var scanning_state: ScanningState

## The target that this enemy is navigating to.  Should always be the player in this case.
var target: Node2D

func _enter_state(args: Dictionary[String,Variant]) -> void:
	target = args["target"]
	if not target is Player:
		push_warning("Target should always be player in ApproachingState")
	nav_timer.start()
	nav_timer.timeout.connect(nav_update)

func _exit_state() -> void:
	nav_timer.stop()
	nav_timer.timeout.disconnect(nav_update)

func _physics_update(_delta: float) -> void:
	character.apply_velocity()
	character.look_at(target.global_position)

func nav_update() -> void:
	# if the player has died, simply return to scanning
	if target == null or not is_instance_valid(target):
		var dict: Dictionary[String,Variant]
		state_changed.emit(scanning_state, dict)
		return
	# if LOS is lost, switch to investigation
	if not detection_component.has_los(target):
		# NOTE: this technically uses the current position of the target instead of the last known
		# position, but this shouldn't be noticable if the nav_timer is fast enough
		var dict: Dictionary[String,Variant] = {"target":target.global_position}
		state_changed.emit(investigating_state, dict)
		return
	if (target.global_position - character.global_position).length() <= engagement_range:
		character.velocity_component.set_velocity(Vector2.ZERO)
		var dict: Dictionary[String,Variant] = {"target":target}
		state_changed.emit(attacking_state, dict)
		return
	nav_agent.target_position = target.global_position
	if nav_agent.is_navigation_finished():
		push_warning("Navigation finished. (This shouldn't occur in ApproachingState.)")
		return
	
	# direction we want to be moving
	var dir: Vector2 = (nav_agent.get_next_path_position() - character.global_position).normalized()
	character.velocity_component.set_velocity(dir * approach_speed)
