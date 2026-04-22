extends Marker3D

func _enter_tree() -> void:
	GameManager.request_spawn_point.connect(send_spawn_point)

func send_spawn_point() -> void:
	visible = false
	GameManager.recieve_spawn_point.emit(global_position, rotation)
