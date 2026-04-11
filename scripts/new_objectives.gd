extends Node

@export var LIST_OF_OBJECTIVES: Dictionary[String, int] = {
	"open door": 0,
	"reach the person": 0,
	"stab": 0,
	"pick walkie-talkie": 0,
	"open drawer": 0,
	"grab dvd": 0,
	"insert dvd": 0,
	"collect wood": 3,
	"kill enemies": 6,
	"kill boss enemy": 0
}

var objective_names_list: Array[String] # The 0 Objective is the current objective here
var objective_amounts_list: Array[int]

var current_objective_name: String
var current_objective_amount: int
var current_completed_amount: int = 0


func _enter_tree() -> void:
	GameManager.request_objective_completed.connect(_check_objective_completed)


func _ready() -> void:
	_update_objective_list(LIST_OF_OBJECTIVES)
	_complete_objective() # this is the start of the objective (for RUSITH)
	#_update_objective_label()

func _update_objective_list(list: Dictionary[String, int]) -> void:
	if list.is_empty(): return
	for i in list.keys(): objective_names_list.append(i)
	for i in list.values(): objective_amounts_list.append(i)


func _check_objective_completed(obj_name: String) -> void:
	if obj_name == current_objective_name:
		print_debug(current_objective_amount)
		GameManager.objective_collected.emit(current_objective_name)
		if current_objective_amount <= 0:
			_complete_objective()
			#_update_objective_label()
		else:
			current_completed_amount += 1
			print_debug(current_completed_amount)
			_update_objective_label(true)

			if current_completed_amount == current_objective_amount:
				_complete_objective()
				#_update_objective_label(true)

func _complete_objective() -> void:
	current_completed_amount = 0
	
	if current_objective_name != "": 
		GameManager.objective_completed.emit(current_objective_name)
		
	if objective_names_list.is_empty() or objective_amounts_list.is_empty():
		current_objective_name = ""
		GameManager.current_objective = ""
		GameManager.update_objective_label.emit("No objectives at the moment")
	else:
		current_objective_name = objective_names_list.pop_front() # THESE ARE THE NEXT OBJECTIVES
		GameManager.current_objective = current_objective_name
		current_objective_amount = objective_amounts_list.pop_front()
		_update_objective_label(current_objective_amount > 0)


func _update_objective_label(numberd: bool = false) -> void:
	var txt: String
	if numberd: txt = "Objective: " + current_objective_name + " ("+str(current_completed_amount)+ "/" +str(current_objective_amount) +")"
	else: txt = "Objective: " + current_objective_name

	GameManager.update_objective_label.emit(txt)
