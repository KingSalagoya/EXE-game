extends Node

@export var interact_text = "pickup wood"
@export var objective_name = "collect wood"
@export var delete: bool = true

var interacted: bool = false

#USELESS VARIABLES BUT NECESSARY TO RUN
var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = true

func _enter_tree() -> void:
	OBJECTIVE = objective_name


func interact() -> void:
	interacted = true
	GameManager.request_objective_completed.emit(objective_name)
	queue_free()
	interacted = false

func _objective_collected(_name: String) -> void:
	print("HIII")
	if _name == objective_name and interacted:
		match _name:
			"collect wood":
				GameManager.inventory.wood += 1
			"grab dvd":
				GameManager.inventory.dvd += 1
			"pick walkie-talkie":
				GameManager.inventory.walkie_talkie += 1
		print(GameManager.inventory)
		if delete:
			queue_free()
		else:
			self.visible = false
