extends MeshInstance3D

@export var interact_text = "talk"
@export var objective_name = "wizard"
@export var delete: bool = true

var interacted: bool = false

var OBJECTIVE
var ACCES_ONLY_WHEN_RELATED_OBJECTIVE = true

func _enter_tree() -> void:
	visible = false
	OBJECTIVE = objective_name

func interact() -> void:
	interacted = true
	AudioManager.play_audio_one_shot("lights off")
	GameManager.request_objective_completed.emit(objective_name)
	GameManager.unlock_achievement.emit("underwater")
	#queue_free()
	interacted = false
	queue_free()


func _physics_process(_delta: float) -> void:
	$StaticBody3D/CollisionShape3D.disabled != visible
