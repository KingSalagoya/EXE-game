extends MeshInstance3D

func _ready() -> void:
	self.show()

func interact() -> void:
	if self.visible == true:
		self.hide()
	else:
		self.show()
