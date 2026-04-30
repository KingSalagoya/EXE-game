extends Node3D

@export var interact_text = "pickup wood"
@export_enum("corpse", "underwater", "normal") var type : String = "normal"
@export var delete: bool = true

@export_category("Corpse")
@export var corpse: Node3D
@export var door_anim: AnimationPlayer
@export_category("Underwater")
@export var underwater_objective_name: String

#USELESS VARIABLES BUT NECESSARY TO RUN
var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = false


func interact() -> void:
	_objective_collected()
	visible = false
	$"../../VillageHouse5/Paper/StaticBody3D/CollisionShape3D".disabled = true

	if type == "corpse":
		_corpse()
	elif type == "underwater":
		_underwater()
	else:
		queue_free()

func _objective_collected() -> void:
	GameManager.inventory.set("notes", GameManager.inventory.get("notes") +1)
	GameManager.diary_note_collected.emit()

func _corpse() -> void:
	corpse.visible = false
	AudioManager.handle_music_pause("horror_theme_song", true)
	AudioManager.handle_music_pause("wind", true)
	await get_tree().create_timer(1).timeout
	door_anim.play("door_open")
	queue_free()

func _underwater() -> void:
	GameManager.request_objective_completed.emit(underwater_objective_name)
	queue_free()
