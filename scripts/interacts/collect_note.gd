extends Node3D

@export var interact_text = "pickup wood"
@export_enum("corpse", "underwater", "normal") var type : String = "normal"
@export var delete: bool = true

@onready var collider: CollisionShape3D = $StaticBody3D/CollisionShape3D

@export_category("Corpse")
@export var corpse: Node3D
@export var door_anim: AnimationPlayer
@export var sun: DirectionalLight3D
@export_category("Underwater")
@export var underwater_objective_name: String
@export var pete_model: Node3D


#USELESS VARIABLES BUT NECESSARY TO RUN
var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = false
var underwater_interacted:bool = false

func interact() -> void:
	_objective_collected()
	visible = false
	collider.disabled = true

	if type == "corpse":
		_corpse()
	elif type == "underwater":
		underwater_interacted = true
		pete_model.visible = true
		door_anim.play("RESET")
		_underwater()
	else:
		queue_free()

func _objective_collected() -> void:
	GameManager.inventory.notes += 1
	GameManager.diary_note_collected.emit()

func _corpse() -> void:
	corpse.visible = false
	AudioManager.handle_music_pause("horror_theme_song", true)
	AudioManager.handle_music_pause("wind", true)
	sun.light_energy = 0.3
	await get_tree().create_timer(1).timeout
	door_anim.play("door_open")
	queue_free()

func _underwater() -> void:
	if not underwater_interacted: return
	GameManager.request_objective_completed.emit(underwater_objective_name)
	queue_free()
