extends Node

@export var interact_text = "pickup wood"
@export var objective_name = "collect wood"

var interacted: bool = false

func _enter_tree() -> void:
	GameManager.objective_collected.connect(_objective_collected)

func interact() -> void:
	interacted = true
	GameManager.request_objective_completed.emit(objective_name)

func _objective_collected(_name: String) -> void:
	if _name == objective_name and interacted:
		queue_free()
