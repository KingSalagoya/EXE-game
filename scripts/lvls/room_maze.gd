extends Node3D

@onready var bulb: OmniLight3D = $BaseRoom/Lighting/bulb

func _ready() -> void:
	GameManager.request_objective_completed.emit("run")
	GameManager.can_toggle_torch = true
	$BaseRoom/Lighting/AnimationPlayer.play("bulb_glitch")
