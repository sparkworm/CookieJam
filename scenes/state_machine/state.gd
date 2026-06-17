## Abstract class to be used with StateMachine
class_name State
extends Node

@warning_ignore_start("unused_parameter")

## Called when this state is made active
func _enter_state(args: Dictionary) -> void:
	pass

## State equivalent of _physics_process()
func _physics_update(delta: float) -> void:
	pass

## State equivalent of _process()
func _update(delta: float) -> void:
	pass

## Called when active state is changing.  Technically a state could change from itself to itself,
## which should still call exit and enter, simulating a reinitialization.
func _exit_state() -> void:
	pass
