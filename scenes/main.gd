## Main Scene, responsible for switching between scenes and handling things on the global level
class_name Main
extends Node

@onready var active_level: CanvasLayer = $ActiveLevel
@onready var ui: CanvasLayer = $UI

func _ready() -> void:
	MessageBus.level_changed.connect(change_level)
	MessageBus.pause_menu_toggled.connect(toggle_pause)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_menu") \
			and Globals.current_level != SceneAccess.Levels.MAIN_MENU:
		MessageBus.pause_menu_toggled.emit()

## Remove of old level scene and add new one
func change_level(lvl_id: SceneAccess.Levels) -> void:
	# ASSUME: there will only be one child
	var to_remove: Node = active_level.get_child(0)
	to_remove.queue_free()
	active_level.remove_child(to_remove)
	var to_add: PackedScene = load(SceneAccess.lvl_dict.get(lvl_id))
	active_level.add_child(to_add.instantiate())
	Globals.current_level = lvl_id

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
