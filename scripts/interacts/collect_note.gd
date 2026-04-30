extends Node

@export var interact_text = "pickup wood"
@export var delete: bool = true

var interacted: bool = false

#USELESS VARIABLES BUT NECESSARY TO RUN
var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = true

func _enter_tree() -> void:
	GameManager.diary_note_collected.connect(_objective_collected)


func interact() -> void:
	interacted = true
	GameManager.diary_note_collected.emit()
	queue_free()
	interacted = false

func _objective_collected(_name: String) -> void:
	GameManager.inventory.notes += 1
