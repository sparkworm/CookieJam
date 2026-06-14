extends Control

@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	start_button.pressed.connect(start_button_pressed)

func start_button_pressed() -> void:
	MessageBus.level_changed.emit(SceneAccess.Levels.TEST_LEVEL)
