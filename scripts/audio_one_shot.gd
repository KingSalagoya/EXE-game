extends AudioStreamPlayer
class_name AudioOneShot

var from_position: float = 0.0
var global_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	finished.connect(self.queue_free)
	#global_position = global_pos
	play(from_position)
