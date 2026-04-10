extends RayCast3D

@export var INTERACT_text: String = "Press E to"

func _physics_process(_delta: float) -> void:
	if GameManager.can_interact:
		_handle_interact()

func _handle_interact() -> void:
	GameManager.update_interact_label.emit("")
	if is_colliding():
		var target = get_collider()
		# Walk up the tree to see if the collider or ANY of its parents are in the group
		while target != null and target is Node:
			if target.is_in_group("interactable"):
					if target.ACCES_ONLY_WHEN_RELATED_OBJECTIVE:
						if GameManager.encounterd_objectives.find(target.OBJECTIVE) == -1:
							break
					if target.interact_text:
						var text: String = str(INTERACT_text + " " + target.interact_text)
						#print(text)
						GameManager.update_interact_label.emit(text)
					if Input.is_action_just_pressed("interact"):
						target.interact()
					break
			target = target.get_parent()
