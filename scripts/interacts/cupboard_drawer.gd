extends MeshInstance3D

var is_open: bool = false

func _ready() -> void:
	position.x = 0.0

func interact() -> void:
	var tween = create_tween()
	if is_open:
		tween.tween_property(self, "position:x", 0.0, 0.5)
		is_open = false
	else:
		tween.tween_property(self, "position:x", -0.40, 0.5)
		is_open = true
