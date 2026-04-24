extends Node3D

@export var INTERACT_TEXT: String = "Interact"
@export var ACCES_ONLY_WHEN_RELATED_OBJECTIVE: bool = false

@export var LIST_OF_NPC_OBJECTIVES: Dictionary[String, int] = {
	"unlock forest": 1,
	"offer weapon": 1,
	"unlock graveyard": 1
}

var interact_text: String
var objective_names_list: Array[String]

func _ready() -> void:
	interact_text = INTERACT_TEXT
	_update_objective_list(LIST_OF_NPC_OBJECTIVES)

func interact() -> void:
	pass

func _update_objective_list(list: Dictionary[String, int]) -> void:
	if list.is_empty(): return
	for i in list.keys(): objective_names_list.append(i)
	
