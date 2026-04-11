extends MeshInstance3D


@onready var title_label: Label = $screen/SubViewport/Control/TextureRect/title
@onready var loading_label: Label = $screen/SubViewport/Control/TextureRect/loading

var dot_count: int = 0

var timer: float = 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0:
		timer -= 1.0
		loading_animation()

func loading_animation() -> void:
	var loading_text: String = "LOADING"
	
	match dot_count:
		0:
			loading_label.text = loading_text + "."
			dot_count += 1
		1:
			loading_label.text = loading_text + ".."
			dot_count += 1
		2:
			loading_label.text = loading_text + "..."
			dot_count += 1
		3:
			loading_label.text = loading_text
			dot_count = 0
