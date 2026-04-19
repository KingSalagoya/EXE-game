class_name reached_area
extends Area3D

@export_enum("Player", "idk") var target_group: String = "Player"
@export var area_id: String = ""
@export var count: int = 1
@export var enable_after_this_objective: String = "none"

var enabled: bool = false

#@export var is_not_player: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if area_id == "": area_id = name

	if enable_after_this_objective == "none": enabled = true
	else: enabled = false

func _physics_process(_delta: float) -> void:
	if enable_after_this_objective == GameManager.current_objective:
		enabled = true

func check_objective() -> void:
	await(get_tree().create_timer(0.3).timeout)
	if GameManager.current_objective != enable_after_this_objective:
		print("im hapi")
		monitoring = true
		monitorable = true

func _on_body_entered(body: Node3D) -> void:
	print_debug(name)
	if count > 0 and body.is_in_group(target_group) and area_id != "" and enabled:
		GameManager.special_area_entered.emit(area_id)
		count -= 1
		print(target_group + " reached the special area of id: " + area_id)
