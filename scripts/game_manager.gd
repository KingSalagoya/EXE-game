extends Node

#Gamestate
@warning_ignore("unused_signal") signal start_game
@warning_ignore("unused_signal") signal end_game
@warning_ignore("unused_signal") signal release_ending
@warning_ignore("unused_signal") signal update_flashlight_counters
@warning_ignore("unused_signal") signal paralize_coords (coords: Vector3, rotation: Vector3)

#Objectives
@warning_ignore("unused_signal") signal request_objective_completed (objective_name: String)
@warning_ignore("unused_signal") signal objective_completed (objective_name: String)
@warning_ignore("unused_signal") signal objective_collected (objective_name: String)
@warning_ignore("unused_signal") signal next_objective
@warning_ignore("unused_signal") signal wood_collected
@warning_ignore("unused_signal") signal update_player_count(count: int)
@warning_ignore("unused_signal") signal update_npc_objective

@warning_ignore("unused_signal") signal diary_note_collected
@warning_ignore("unused_signal") signal activate_sub_objective(state: bool)


#Labels
@warning_ignore("unused_signal") signal update_interact_label(text: String)
@warning_ignore("unused_signal") signal update_objective_label(text: String)

#Dialogues
@warning_ignore("unused_signal") signal play_cinamatic (anim_name: String)
@warning_ignore("unused_signal") signal handle_dialogue (resourse, title: String)
@warning_ignore("unused_signal") signal chat_dialogue (num: int)
@warning_ignore("unused_signal") signal dialogue_finished

@warning_ignore("unused_signal") signal change_scene (level: String)
@warning_ignore("unused_signal") signal unhandled_input (input: String)

@warning_ignore("unused_signal") signal unlock_achievement (achievement: String)
@warning_ignore("unused_signal") signal spawn_boss_enemy ()
@warning_ignore("unused_signal") signal spawn_friend ()

@warning_ignore("unused_signal") signal handle_exit ()

#Special Areas
@warning_ignore("unused_signal") signal special_area_entered (area_id: String)

#SpawnPoint
@warning_ignore("unused_signal") signal request_spawn_point()
@warning_ignore("unused_signal") signal recieve_spawn_point(_position: Vector3, _rotation: Vector3)

var can_toggle_chat: bool = false
var can_move: bool = true
var can_jump: bool = false
var can_interact: bool = true
var current_objective: String = ""
var current_objective_clone: String = ""

#region npc_vars

var has_spoke: bool = false
var needed_woods: int = 3

#endregion

var collected_all_notes: bool = false
var encounterd_objectives: Array[String] = []

var inventory:Dictionary [String, int] = {
	"wood": 0,
	"dvd": 0,
	"walkie_talkie": 0,
	"notes": 0
}

#region dialogue_manager

func get_wood() -> int:
	return inventory["wood"]

func get_needed_wood() -> int:
	return 3 - inventory["wood"]

#endregion

func _enter_tree() -> void:
	current_objective_clone = current_objective

func _physics_process(_delta: float) -> void:
	if current_objective != "" and current_objective_clone != current_objective:
		encounterd_objectives.append(current_objective)
		current_objective_clone = current_objective

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"): unhandled_input.emit("enter")
	if event.is_action_pressed("jump"): unhandled_input.emit("jump")
	if event.is_action_pressed("exit"): handle_exit.emit()
