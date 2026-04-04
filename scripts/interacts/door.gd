extends MeshInstance3D

@onready var stats_displayer: Control = get_tree().current_scene.find_child("Stats", true, false)

func _ready() -> void:
	self.show()

func interact() -> void:
	if self.visible == true:
		self.hide()
		if stats_displayer:
			stats_displayer.objectives["Open Door"] = stats_displayer.state.done
			await get_tree().create_timer(1).timeout
			stats_displayer.objectives["Build the game"] = stats_displayer.state.allowed

	else:
		self.show()
