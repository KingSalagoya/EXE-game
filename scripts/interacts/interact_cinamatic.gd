extends Node

@export var interact_text: String = "Stab"
@export var OBJECTIVE: String = "stab"
@export var CINAMATIC_NAME: String = "stab"
@export var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = true


func interact() -> void:
	interact_text = " "
	GameManager.request_objective_completed.emit(OBJECTIVE)
	GameManager.play_cinamatic.emit(CINAMATIC_NAME)
