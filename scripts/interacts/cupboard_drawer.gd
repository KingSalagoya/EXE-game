extends MeshInstance3D

@onready var stats_displayer: Control = get_tree().current_scene.find_child("Stats", true, false)

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
		if stats_displayer:
			stats_displayer.objectives["Open Drawer"] = stats_displayer.state.done
			await get_tree().create_timer(1).timeout
			stats_displayer.objectives["Open Door"] = stats_displayer.state.allowed
