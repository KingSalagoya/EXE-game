extends Node

@onready var chat_ui: Control = $GameEnviroment/Player/CameraHolder/MainCamera/ChatUI

func _ready() -> void:
	%UserInterface.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		if chat_ui.visible == false:
			get_tree().quit()
