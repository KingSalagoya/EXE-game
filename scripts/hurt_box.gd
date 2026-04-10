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
				owner_character.queue_free()
			else:
				get_tree().quit()
