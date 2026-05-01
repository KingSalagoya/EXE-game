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
func _ready() -> void:
	if pete_model:
		GameManager.jumpscare_pete = pete_model
	if corpse:
		GameManager.corpse = corpse

func interact() -> void:
	visible = false
	collider.disabled = true

	if type == "corpse":
		GameManager.show_half_news.emit()
		_objective_collected()
		_corpse()
	elif type == "underwater":
		pete_model.visible = true
		door_anim.play("RESET")
		GameManager.display_note.emit(false)
		GameManager.collected_all_notes = true
		_objective_collected()
		_underwater()
	else:
		_objective_collected()
		GameManager.display_note.emit()
		queue_free()

func _objective_collected() -> void:
	GameManager.inventory.notes += 1
	GameManager.diary_note_collected.emit()

func _corpse() -> void:
	corpse.visible = false
	AudioManager.stop_all_muisc()
	sun.light_energy = 0.3
	await get_tree().create_timer(0.7).timeout
	AudioManager.play_audio_one_shot("running away")
	await get_tree().create_timer(0.3).timeout
	door_anim.play("door_open")
	GameManager.corpse_seen.emit()
	queue_free()

func _underwater() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()
