extends Node

enum state {allowed, blocked, done}

@export var OBJECTIVES: Dictionary[String, state] = {
	"open drawer": state.allowed,
	"open door": state.blocked,
	"Grab Walkie Talkie": state.blocked,
	"Grab DVD": state.blocked,
	"Collect Wood": state.blocked,
	"Build the game": state.blocked
}

func _ready() -> void:
	GameManager.update_objective_label.emit("")
	GameManager.next_objective.connect(_next_objective)

func _physics_process(_delta: float) -> void:
	var current_text = ""
	for obj_name in OBJECTIVES:
		if OBJECTIVES[obj_name] == state.allowed:
			current_text = "Objective: " + obj_name
			break
			
	GameManager.update_objective_label.emit(current_text)

func _next_objective(interact_text: String) -> void:
	var keys = OBJECTIVES.keys()
	
	for obj in OBJECTIVES:
		if OBJECTIVES[obj] == state.allowed and obj == interact_text:
			OBJECTIVES[obj] = state.done
			
			var obj_index = keys.find(obj)
			#print(str(obj_index) + " / " + str(keys.size() - 1))
			
			await get_tree().create_timer(1).timeout
			var next_index = obj_index + 1
			
			if next_index < keys.size():
				var next_obj = keys[next_index]
				OBJECTIVES[next_obj] = state.allowed
			return
