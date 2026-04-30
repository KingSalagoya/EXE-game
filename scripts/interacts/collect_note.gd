extends Node

@export var interact_text = "pickup wood"
@export var delete: bool = true

var hi : Dictionary[String,int] = {"hi": 1}

#USELESS VARIABLES BUT NECESSARY TO RUN
var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = false


func interact() -> void:
	_objective_collected()
	queue_free()

func _objective_collected() -> void:
	GameManager.inventory.set("notes", GameManager.inventory.get("notes") +1)
	GameManager.diary_note_collected.emit()
