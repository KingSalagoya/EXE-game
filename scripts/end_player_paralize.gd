extends Marker3D

func _ready() -> void:
	visible = false
	GameManager.release_ending.connect(activate)

func activate() -> void:
	GameManager.paralize_coords.emit(global_position, global_rotation)
