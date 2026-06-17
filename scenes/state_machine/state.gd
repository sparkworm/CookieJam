## Abstract class to be used with StateMachine
class_name State
extends Node

@warning_ignore("unused_signal")
## I think in the past I've given states a reference to their state machine so they could call
## change_state() directly, but I think a signal is better design
signal state_changed(new_state: State, args: Dictionary)

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

## Called by state machine when active state is changing.  
## NOTE: that this should NOT be called within State
func _exit_state() -> void:
	pass
