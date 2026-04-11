class_name hit_box

extends Area3D

@export var damage: int = 10
@export var default_knockback: float = 8.0
@export var owner_character: CharacterBody3D
@export var passive_damage: bool = true
@export var attackable: bool = true

func _ready() -> void:
	if owner_character == null:
		var parent = get_parent()
		if parent is CharacterBody3D:
			owner_character = parent

	if passive_damage:
		area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is hurt_box and attackable:
		#don't hurt ourselves if both belong to the same character
		if owner_character and area.owner_character == owner_character:
			return
		
		var current_damage = damage
		var current_knockback = default_knockback
		
		if owner_character:
			if "damage" in owner_character:
				current_damage = owner_character.damage
			if "knockback_force" in owner_character:
				current_knockback = owner_character.knockback_force
			
		var direction = (area.global_position - global_position).normalized()
		# add a little vertical kick to the knockback...
		direction.y += 0.3
		direction = direction.normalized()
		
		var knockback_vector = direction * current_knockback
		area.take_damage(current_damage, knockback_vector)

func deal_damage() -> void:
	for area in get_overlapping_areas():
		_on_area_entered(area)
