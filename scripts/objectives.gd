extends Node

enum state {allowed, blocked, done}

@export var OBJECTIVES: Dictionary[String, state] = {
	"Open Drawer": state.allowed,
	"Open Door": state.blocked,
	"Grab Walkie Talkie": state.blocked,
	"Grab DVD": state.blocked,
	"Collect Wood": state.blocked,
	"Build the game": state.blocked
}


func _ready() -> void:
	GameManager.update_objective_label.emit("")

func _physics_process(_delta: float) -> void:
	for obj_name in OBJECTIVES:
		if OBJECTIVES[obj_name] == state.allowed:
			GameManager.update_objective_label.emit("Objective: " + obj_name)
			return
		else: 
			GameManager.pdate_objective_label.emit("")
