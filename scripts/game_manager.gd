extends Node

@warning_ignore("unused_signal") signal start_game
@warning_ignore("unused_signal") signal end_game

#Objectives
@warning_ignore("unused_signal") signal request_objective_completed (objective_name: String)
@warning_ignore("unused_signal") signal objective_completed (objective_name: String)
@warning_ignore("unused_signal") signal objective_collected (objective_name: String)
@warning_ignore("unused_signal") signal next_objective
@warning_ignore("unused_signal") signal wood_collected

#Labels
@warning_ignore("unused_signal") signal update_interact_label(text: String)
@warning_ignore("unused_signal") signal update_objective_label(text: String)

#Dialogues
@warning_ignore("unused_signal") signal play_cinamatic (anim_name: String)
@warning_ignore("unused_signal") signal handle_dialogue (resourse, title: String)
@warning_ignore("unused_signal") signal chat_dialogue (num: int)


@warning_ignore("unused_signal") signal change_scene (level: String)
@warning_ignore("unused_signal") signal unhandled_input (input: String)

var can_move: bool = true
var current_objective: String = ""
var inventory:Dictionary [String, int] = {
	"wood": 0,
	"dvd": 0,
	"walkie_talkie": 0
}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"): unhandled_input.emit("enter")
	if event.is_action_pressed("jump"): unhandled_input.emit("jump")
	if event.is_action_pressed("exit"): get_tree().quit()
