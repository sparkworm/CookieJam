## Pathfind to a given point, be it a sound or last known location of player.
## Updates pathfinding target if another sound is heard.
## [br]Changes to:
## [br] - Approaching: Player spotted
## [br] - Scanning: Destination reached
class_name InvestigatingState
extends State

@export var approaching_state: ApproachingState
@export var scanning_state: ScanningState

## Component for detecting the player.  We will want to connect to its detection signals, but we
## MUST remember to disconnect in _exit_state()
@export var detection_component: DetectionComponent
@export var nav_agent: NavigationAgent2D
@export var nav_timer: Timer
@export var character: Enemy

## The speed at which the enemy will move along its path to investigate the target position.
@export var investigate_speed: float = 100

## NOTE: Technically not used, since nav_agent.target_position is set in _enter_state()
## TODO: remove once no longer useful to debugging
var target_position: Vector2

## ASSUME: args has a value with key "target"
func _enter_state(args: Dictionary[String,Variant]) -> void:
	target_position = args["target"]
	nav_agent.target_position = target_position
	detection_component.target_spotted.connect(player_spotted)
	nav_timer.start()
	nav_timer.timeout.connect(nav_update)

func _exit_state() -> void:
	detection_component.target_spotted.disconnect(player_spotted)
	nav_timer.stop()
	nav_timer.timeout.disconnect(nav_update)

func _physics_update(_delta: float) -> void:
	character.apply_velocity()

func nav_update() -> void:
	# dict for switching to another state (either one would require the same dict)
	if nav_agent.is_navigation_finished():
		var dict: Dictionary[String,Variant] = {}
		state_changed.emit(scanning_state, dict)
		return
	
	# direction we want to be moving
	var dir: Vector2 = (nav_agent.get_next_path_position() - character.global_position).normalized()
	character.velocity_component.set_velocity(dir * investigate_speed)

## The player has entered the Vision cone and we have LOS: change to approach state
func player_spotted(player: Node2D) -> void:
	state_changed.emit(approaching_state, {"target":player})
