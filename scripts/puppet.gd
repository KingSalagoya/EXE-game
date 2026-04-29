extends Node3D

func _physics_process(delta: float) -> void:
	if visible:
		look_at(%Player.global_position)
		rotation.x = 0
		rotation.z = 0
