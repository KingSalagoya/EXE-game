class_name reached_area
extends Area3D

@export_enum("Player", "idk") var target_group: String = "Player"
@export var area_id: String = ""
@export var count: int = 1


#@export var is_not_player: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if area_id == "": area_id = name

func _on_body_entered(body: Node3D) -> void:
	if count > 0 and body.is_in_group(target_group) and area_id != "":
		GameManager.special_area_entered.emit(area_id)
		count -= 1
		print(target_group + " reached the special area of id: " + area_id)
