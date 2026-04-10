extends Control

@onready var chat_ui: Control = $MarginContainer/ChatUI
@onready var interact_label: Label = $MarginContainer/HUD/InteractLabel
@onready var objective_label: Label = $MarginContainer/HUD/ObjectiveLabel
@onready var achievement_label: Label = $MarginContainer/HUD/AchievementLabel

var stored_objective_label: String

func _enter_tree() -> void:
	GameManager.update_interact_label.connect(update_interact_label)
	GameManager.update_objective_label.connect(update_objective_text)
	GameManager.unlock_achievement.connect(update_achievement_label)

func _ready() -> void:
	toggle_chat_display()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Toggle Chat Visibility"): toggle_chat_display()


func update_interact_label(text: String) -> void:
	if text == "" : interact_label.hide()
	else: interact_label.show()
	text = "Press E to " + text
	interact_label.text = text

func update_achievement_label(achievement: String) -> void:
	if achievement == "" : achievement_label.hide()
	else: achievement_label.show()
	var text = "New Zone Unlocked: " + achievement.to_upper()
	achievement_label.text = text
	await get_tree().create_timer(3).timeout
	GameManager.unlock_achievement.emit("")

func update_objective_text(text: String) -> void:
	stored_objective_label = text
	update_objective_label()
	#objective_label.text = text

func update_objective_label() -> void:
	if stored_objective_label == "" : objective_label.hide()
	else: objective_label.show()
	if stored_objective_label != "":
		objective_label.text = stored_objective_label

func toggle_chat_display() -> void:
	if not chat_ui.visible:
		chat_ui.show()
		GameManager.can_move = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		chat_ui.hide()
		GameManager.can_move = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
