extends Control

@onready var main: Node = $"../../../../.."

var started: bool = false
var current_state: bool
var current_mouse_mode

const level_zero: PackedScene = preload("res://scenes/room.tscn")

func _enter_tree() -> void:
	GameManager.handle_exit.connect(_handle_exit)
	visible = false
	$Options.visible = false
	_handle_exit()

func _on_start_pressed() -> void:
	if started == false:
		var restart_btn = $Buttons/Start.duplicate()
		
		restart_btn.name = "Restart"
		restart_btn.text = "Restart"
		
		$Buttons.add_child(restart_btn)
		
		$Buttons.move_child(restart_btn, 1)
		
		restart_btn.pressed.connect(_on_restart_pressed)
		
		$Buttons/Start.text = "Continue"
		started = true
	_handle_exit()

func _on_restart_pressed() -> void:
	main.change_level(level_zero)

func _on_options_pressed() -> void:
	$Buttons.hide()
	$Options.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _handle_exit() -> void:
	if visible == true:
		if $Options.visible == false:
			GameManager.can_move = current_state
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			visible = false
		else:
			$Options.visible = false
			$Buttons.visible = true
	else:
		current_state = GameManager.can_move
		GameManager.can_move = false
		#current_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		visible = true


func _on_exit_pressed() -> void: # options menu exit
	$Options.hide()
	$Buttons.show()
