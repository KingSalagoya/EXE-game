class_name reached_area

extends Area3D

@export var target_group: String = "Player"
@export var count: int = 1
@export var emit_name: String = ""

#@export var is_not_player: bool = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if emit_name == "":
		push_error("Signal name not defined.")

func _on_area_entered(area: CharacterBody3D) -> void:
	if count > 0 and area.is_in_group(target_group):
		if emit_name != "":
			GameManager.special_area_entered.emit(emit_name)
			count -= 1
		print("Reached the area!")
