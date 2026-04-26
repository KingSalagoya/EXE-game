class_name hurt_box

extends Area3D

@export var owner_character: CharacterBody3D

func _ready() -> void:
	if owner_character == null:
		var parent = get_parent()
		if parent is CharacterBody3D:
			owner_character = parent

func take_damage(damage: int, knockback: Vector3 = Vector3.ZERO) -> void:
	if owner_character == null:
		return
		
	if "hp" in owner_character:
		owner_character.hp -= damage
		print(owner_character.name, " took ", damage, " damage. HP left: ", owner_character.hp)
		
		if knockback != Vector3.ZERO and owner_character.has_method("apply_knockback"):
			owner_character.apply_knockback(knockback)
		
		# add hurt animation here
		if owner_character.hp <= 0:
			if owner_character.name != "Player":
				if owner_character.character and owner_character.character == owner_character.CHARACTER.boss:
					GameManager.request_objective_completed.emit("kill boss enemy")
				else:
					GameManager.request_objective_completed.emit("kill enemies")
				owner_character.queue_free()
			else:
				GameManager.unlock_achievement.emit("You DIED!")
				get_tree().paused = true
				await get_tree().create_timer(1).timeout
				get_tree().paused = false
				get_tree().reload_current_scene()
