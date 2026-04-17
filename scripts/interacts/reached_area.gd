class_name reached_area

extends Area3D

enum TYPE {animation, objective}

@export var type: TYPE = TYPE.objective
@export var objective_name: String
@export var animation_player: AnimationPlayer
@export var animation_name: String


#@export var is_not_player: bool = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is hurt_box:
		match type:
			TYPE.objective:
				_update_objective()
			TYPE.animation:
				_play_animation()

func _update_objective() -> void:
	GameManager.request_objective_completed.emit(objective_name)
	GameManager.can_move = false
	print("Player Reached | Objective Updated!")

func _play_animation() -> void:
	if animation_player and animation_name:
					animation_player.play(animation_name)
					print("Player Reached | " + animation_name + " Played!")
