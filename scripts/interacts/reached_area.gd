class_name reached_area

extends Area3D

@export var objective_name: String

@export var is_not_player: bool = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is hurt_box:
		GameManager.request_objective_completed.emit(objective_name)
		GameManager.can_move = false
		print("Player Reached")
		#GameManager.request_objective_completed.emit("stab")
