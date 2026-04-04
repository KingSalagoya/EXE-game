extends Control

@onready var chat_ui: Control = $MarginContainer/ChatUI
@onready var interact_label: Label = $MarginContainer/HUD/InteractLabel
@onready var objective_label: Label = $MarginContainer/HUD/ObjectiveLabel


func _enter_tree() -> void:
	GameManager.update_interact_label.connect(update_interact_label)
	GameManager.update_objective_label.connect(update_objective_label)

func _ready() -> void:
	toggle_chat_display()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Toggle Chat Visibility"): toggle_chat_display()


func update_interact_label(text: String) -> void:
	if text == "" : interact_label.hide()
	else: interact_label.show()
	interact_label.text = text


func update_objective_label(text: String) -> void:
	if text == "" : objective_label.hide()
	else: objective_label.show()
	objective_label.text = text


func toggle_chat_display() -> void:
	if not chat_ui.visible:
		chat_ui.show()
		GameManager.can_move = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		chat_ui.hide()
		GameManager.can_move = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
