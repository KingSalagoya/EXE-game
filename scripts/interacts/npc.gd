extends Node3D

@export var INTERACT_TEXT: String = "Interact"
@export var ACCES_ONLY_WHEN_RELATED_OBJECTIVE: bool = false

@export var LIST_OF_NPC_OBJECTIVES: Dictionary[String, int] = {
	"unlock forest": 1,
	"offer weapon": 1,
	"unlock graveyard": 1
}

const NPC_Dialogue = preload("uid://croffpocd4445")

var interact_text: String

var has_spoke: bool = false

var objective_names_list: Array[String]
var objective_amounts_list: Array[int]

var current_objective_name: String
var current_objective_amount: int
var current_completed_amount: int = 0

func _ready() -> void:
	interact_text = INTERACT_TEXT
	_update_objective_list()
	_set_current_objective()
	print(objective_amounts_list)
	print(objective_names_list)

func interact() -> void:
	if GameManager.can_interact:
		_set_current_objective(LIST_OF_NPC_OBJECTIVES)
		_play_dialogue(current_objective_name)

func _update_objective_list(list: Dictionary[String, int] = LIST_OF_NPC_OBJECTIVES) -> void:
	if list.is_empty(): return
	for i in list.keys(): objective_names_list.append(i)
	for i in list.values(): objective_amounts_list.append(i)

func _set_current_objective(list: Dictionary[String, int] = LIST_OF_NPC_OBJECTIVES) -> void:
	if list.is_empty(): return
	current_completed_amount = 0
	for i in list.values():
		if i == 1:
			current_objective_amount = i
			current_objective_name = objective_names_list[current_completed_amount]
			break
		else:
			current_completed_amount += 1

func _update_current_objective(list: Dictionary[String, int] = LIST_OF_NPC_OBJECTIVES) -> void:
	if list.is_empty(): return
	current_completed_amount = 0
	for i in list.values():
		if i == 1:
			i = 0
			current_objective_amount = i + 1
			current_objective_name = objective_names_list[current_completed_amount]
			break
		else:
			current_completed_amount += 1

func _play_dialogue(objective: String) -> void:
	match objective:
		"unlock forest":
			if GameManager.inventory.wood >= 3:
				_update_current_objective()
			GameManager.handle_dialogue.emit(NPC_Dialogue, "unlock_forest")
			if not GameManager.has_spoke:
				GameManager.has_spoke = true
