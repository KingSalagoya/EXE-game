class_name reached_area

extends Area3D

@export var objective_name: String

@export var is_not_player: bool = true

func _ready() -> void:
	if $"../CameraHolder":
		$"../CameraHolder".queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area.is_not_player:
		return
	elif area is hurt_box:
		GameManager.request_objective_completed.emit(objective_name)
		GameManager.can_move = false
		print("Reached")
