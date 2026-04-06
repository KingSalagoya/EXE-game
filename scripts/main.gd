extends Node

@onready var level_holder: Node3D = $GameEnviroment/LevelHolder
@onready var dialogue_balloon: DialogueManagerExampleBalloon = $GameEnviroment/DialogueBalloon

const level_test: PackedScene = preload("res://scenes/level_test.tscn")
const level_room: PackedScene = preload("res://scenes/room.tscn")

func _enter_tree() -> void:
	GameManager.handle_dialogue.connect(_handle_dialogue)
	GameManager.objective_completed.connect(_special_objectives)

func _special_objectives(_name: String) -> void:
	match _name:
		"open door":
			change_level(level_test)
		"collect wood":
			change_level(level_room)
		"grab dvd":
			GameManager.handle_dialogue.emit(preload("res://dialogue/room#1.dialogue"), "recall_past")

func change_level(new_scene: PackedScene) -> void:
	var prev_level = level_holder.get_child(0)
	prev_level.queue_free()
	var new_level = new_scene.instantiate()
	level_holder.add_child(new_level)
	%Player.global_position = Vector3.ZERO

func _ready() -> void:
	%UserInterface.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	await  get_tree().create_timer(1).timeout
	GameManager.handle_dialogue.emit(preload("res://dialogue/room#1.dialogue"), "start")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"): get_tree().quit()

func _handle_dialogue(resourse, title):
	dialogue_balloon.dialogue_resource = resourse 
	dialogue_balloon.start_from_title = title
	dialogue_balloon.start()
