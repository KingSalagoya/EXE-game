extends RayCast3D

@export var INTERACT_TEXT: String = "Press E to"

func _physics_process(_delta: float) -> void:
	_handle_interact()

func _handle_interact() -> void:
	GameManager.update_interact_label.emit("")
	if is_colliding():
		var target = get_collider()
		# Walk up the tree to see if the collider or ANY of its parents are in the group
		while target != null and target is Node:
			if target.is_in_group("interactable"):
				GameManager.update_interact_label.emit(INTERACT_TEXT + target.interact_text)
				if Input.is_action_just_pressed("interact"):
					target.interact()
				break
			target = target.get_parent()
