## Basically the same state machine that I've made a zillion times
class_name StateMachine
extends Node

@export var active_state: State

func _ready() -> void:
	# starting state should be able to be entered with no arguments
	active_state._enter_state({})

func _physics_process(delta: float) -> void:
	active_state._physics_update(delta)

func _process(delta: float) -> void:
	active_state._update(delta)

func change_state(new_state: State, args: Dictionary) -> void:
	active_state._exit_state()
	active_state = new_state
	active_state._enter_state(args)
