class_name  hurt_box

extends Area3D

@export var owner_character: CharacterBody3D

func _ready() -> void:
	pass

func take_damage(damage: int) -> void:
	owner_character.hp -= damage
	# add hurt animation here
	if owner_character.hp <= 0:
		if owner_character.name != "Player":
			owner_character.queue_free()
		else:
			get_tree().quit()
