class_name PauseMenu
extends Control

func _ready() -> void:
	MessageBus.pause_menu_toggled.connect(toggle_pause)

func toggle_pause() -> void:
	visible = not visible

func _on_resume_button_pressed() -> void:
	MessageBus.pause_menu_toggled.emit()

func _on_restart_level_button_pressed() -> void:
	MessageBus.level_changed.emit(Globals.current_level)
	MessageBus.pause_menu_toggled.emit()

func _on_main_menu_button_pressed() -> void:
	MessageBus.level_changed.emit(SceneAccess.Levels.MAIN_MENU)
	MessageBus.pause_menu_toggled.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
