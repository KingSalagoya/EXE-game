extends Node

func _ready() -> void:
	%UserInterface.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): get_tree().quit()
