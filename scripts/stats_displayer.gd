extends Control

@onready var objective_label: Label = $BoxContainer/Objective

enum state {allowed, blocked, done}

var objectives: Dictionary = {
	"Open Drawer": state.allowed,
	"Open Door": state.blocked,
	"Grab Walkie Talkie": state.blocked,
	"Grab DVD": state.blocked,
	"Collect Wood": state.blocked,
	"Build the game": state.blocked
}

func _ready() -> void:
	objective_label.text = ""
	objective_label.hide()

func _process(_delta: float) -> void:
	for obj_name in objectives:
		if objectives[obj_name] == state.allowed:
			objective_label.show()
			objective_label.text = "Objective: " + obj_name
			return
		else:
			objective_label.text = ""
			objective_label.hide()
