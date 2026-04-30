extends Control

@onready var chat_ui: Control = $MarginContainer/ChatUI
@onready var msg_box: LineEdit = $"MarginContainer/ChatUI/VBoxContainer/msg box"
@onready var chat_history: TextEdit = $"MarginContainer/ChatUI/VBoxContainer/chat history"

@onready var interact_label: Label = $MarginContainer/HUD/InteractLabel
@onready var objective_label: Label = $MarginContainer/HUD/ObjectiveLabel
@onready var sub_objective_label: Label = $MarginContainer/HUD/SubObjectiveLabel
@onready var achievement_label: Label = $MarginContainer/HUD/AchievementLabel
@onready var player_count_label: Label = $MarginContainer/HUD/Player_Count_Label
@onready var note_display: TextEdit = $MarginContainer/Notes/TextEdit
@onready var notes: Control = $MarginContainer/Notes

var stored_objective_label: String
var ending_label: bool = false
var should_hide_note: bool = false

func _enter_tree() -> void:
	GameManager.update_interact_label.connect(update_interact_label)
	GameManager.update_objective_label.connect(update_objective_text)
	GameManager.unlock_achievement.connect(update_achievement_label)
	GameManager.update_player_count.connect(update_player_count_label)
	GameManager.release_ending.connect(ending)
	GameManager.diary_note_collected.connect(update_sub_objective)
	GameManager.activate_sub_objective.connect(activate_sub_objectives)

func _ready() -> void:
	activate_sub_objectives()
	update_sub_objective()
	#set_chat_mode("off")
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Toggle Chat Visibility"): toggle_chat_display()
	
	if should_hide_note:
		if Input.is_action_just_pressed("Enter"):
			notes.hide()
			GameManager.can_move = true
			should_hide_note = false


func update_interact_label(text: String) -> void:
	if text == "" : interact_label.hide()
	else: interact_label.show()
	#text = "Press E to " + text
	interact_label.text = text

func ending() -> void:
	GameManager.update_interact_label.disconnect(update_interact_label)
	update_interact_label("Press F to toggle flashlight")
	await get_tree().create_timer(3).timeout
	update_interact_label("")
	ending_label = true

func update_player_count_label(count: int) -> void:
	if count <= 0 : player_count_label.hide()
	else: player_count_label.show()
	var text = "Players online:  " + str(count)
	player_count_label.text = text

func update_achievement_label(achievement: String, is_achievement: bool = true) -> void:
	if not is_instance_valid(achievement_label):
		return
	if achievement == "" : achievement_label.hide()
	else: achievement_label.show()
	var text
	if is_achievement:
		text = "New Zone Unlocked: " + achievement.to_upper()
		achievement_label.modulate.r = 255
		achievement_label.modulate.g = 255
	else:
		text =  achievement.to_upper()
		if "DIED" in text:
			achievement_label.modulate.r = 0
			achievement_label.modulate.g = 0
	achievement_label.text = text
	await get_tree().create_timer(3).timeout
	GameManager.unlock_achievement.emit("")

func update_objective_text(text: String) -> void:
	stored_objective_label = text
	update_objective_label()
	#objective_label.text = text

func _physics_process(_delta: float) -> void:
	if ending_label:
		pass
		#update_interact_label("Press F to toggle flashlight")
		await get_tree().create_timer(2).timeout

func update_objective_label() -> void:
	if stored_objective_label == "" : objective_label.hide()
	else: objective_label.show()
	if stored_objective_label != "":
		objective_label.text = stored_objective_label

func toggle_chat_display() -> void:
	if GameManager.can_toggle_chat:
		if not msg_box.visible:
			msg_box.show()
			chat_history.modulate.a = 1.0
			GameManager.can_move = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			msg_box.hide()
			chat_history.modulate.a = 0.78
			GameManager.can_move = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_chat_mode(state: String) -> void:
	match state:
		"on":
			chat_ui.show()
			msg_box.hide()
			chat_history.modulate.a = 0.78
		"off":
			chat_ui.hide()
			msg_box.show()
			chat_history.modulate.a = 1.0

#region sub_objectives

func update_sub_objective() -> void:
	if GameManager.inventory.get("notes") < 6:
		sub_objective_label.text = "Sub Objective: Collect Mystery Notes (" + str(GameManager.inventory.get("notes")) + "/6)"
	elif GameManager.collected_all_notes == false:
		sub_objective_label.text = "Sub Objective Completed!"
		await get_tree().create_timer(1).timeout
		sub_objective_label.text = ""
		sub_objective_label.hide()
		GameManager.collected_all_notes = true

func activate_sub_objectives(state: bool = false) -> void:
	if state:
		sub_objective_label.show()
	else:
		sub_objective_label.hide()

func display_notes() -> void:
	note_display.texy = ""
	match GameManager.inventory.notes:
		1:
			note_display.text = """'Do you know what ARU told me about PETE?'
			'OMG, I knew it.'"""
		2:
			note_display.text = """ARU, you broke his trust."""
		3:
			note_display.texy = """'I knew PETE was a freak'
			'Thank you, ARU, for telling me his deepest darkest secret.'"""
		4:
			note_display.texy = """Oh, it’s not your fault. It is Pete’s fault."""
		5:
			note_display.texy = """'Stella Told Me That.'
			'Oh, that is a perfect reason to bully him.'"""
		6:
			note_display.texy = """'I thought Pete was a good guy.'
			'Pete. Such a loser.'"""
	notes.show()
	GameManager.can_move = false
	should_hide_note = true

#endregion
