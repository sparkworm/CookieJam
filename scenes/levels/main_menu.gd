extends Control

@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(start_button_pressed)
	quit_button.pressed.connect(quit_button_pressed)

func start_button_pressed() -> void:
	MessageBus.level_changed.emit(SceneAccess.Levels.TEST_LEVEL)

func quit_button_pressed() -> void:
	get_tree().quit()
