extends Node

@onready var level_holder: Node3D = $GameViewport/SubViewport/GameEnviroment/LevelHolder
@onready var dialogue_balloon: DialogueManagerExampleBalloon = $UiViewport/SubViewport/UserInterface/Dialogue

@onready var blink_anim: AnimationPlayer = $UiViewport/SubViewport/Blink/blink_anim
@onready var cinamatics_player: AnimationPlayer = $GameViewport/SubViewport/GameEnviroment/Cinamatic/CinamaticsPlayer

@onready var ui: Control = %UserInterface
@onready var chat_ui: Control = $UiViewport/SubViewport/UserInterface/MarginContainer/ChatUI


const level_test: PackedScene = preload("res://scenes/levels/level_test.tscn")
const level_zero: PackedScene = preload("res://scenes/levels/room.tscn")
const level_one: PackedScene = preload("res://scenes/levels/room2.tscn")


const room_one_dialogue: DialogueResource = preload("res://dialogue/room#1.dialogue")

func _enter_tree() -> void:
	GameManager.handle_exit.connect(exit_game)
	GameManager.handle_dialogue.connect(_handle_dialogue)
	GameManager.objective_completed.connect(_special_objectives)
	GameManager.change_scene.connect(_change_level)
	GameManager.play_cinamatic.connect(_play_cinamatic)
	GameManager.special_area_entered.connect(_handle_special_area)

func _ready() -> void:
	%UserInterface.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	blink_anim.play("blink")

func _process(_delta: float) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$UiViewport.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		$UiViewport.mouse_filter = Control.MOUSE_FILTER_PASS

func exit_game() -> void:
	get_tree().quit()

#region main_situations
func _special_objectives(_name: String) -> void:
	match _name:
		"reach the telephone line":
			print("yeeeeeeeeeeeeeeeeeee!")
#			var knife: Node3D = get_node_or_null("GameViewport/SubViewport/GameEnviroment/LevelHolder/Home/knife")
#			knife.show()
#			var animation_player: AnimationPlayer = get_node_or_null("GameViewport/SubViewport/GameEnviroment/LevelHolder/Home/AnimationPlayer")
#			animation_player.play("cut the wire")
#			await animation_player.animation_finished
			await get_tree().create_timer(1).timeout
			GameManager.request_objective_completed.emit("cut the telephone line")
		"stab":
			GameManager.can_move = false
			await(get_tree().create_timer(11).timeout)
			%Player.global_position = Vector3(-1.08, 0.914, -1.83)
			_change_level(level_one)
			wake_up()
		"pick walkie-talkie":
			GameManager.can_move = false
			await get_tree().create_timer(2).timeout
			GameManager.handle_dialogue.emit(room_one_dialogue, "grab_walkie_talkie")
			GameManager.can_move = true
		"grab dvd":
			GameManager.handle_dialogue.emit(room_one_dialogue, "grab_dvd")
		"open door":
			pass
		"collect wood":
			GameManager.unlock_achievement.emit("graveyard")
		"insert dvd":
			GameManager.can_move = false
			cinamatics_player.play("play_computer")
			await get_tree().create_timer(5).timeout
			GameManager.handle_dialogue.emit(room_one_dialogue, "insert_dvd")
			await GameManager.dialogue_finished
			blink_anim.play_backwards("blink")
			await get_tree().create_timer(3).timeout
			cinamatics_player.play("RESET")
			_change_level(level_test)
			GameManager.can_move = true
			blink_anim.play("blink")
			GameManager.update_player_count.emit(1)
			%Player.SPEED = 5
		"kill enemies":
			GameManager.spawn_boss_enemy.emit()
			GameManager.spawn_friend.emit()
		"kill boss enemy":
			var friend = $GameViewport/SubViewport/GameEnviroment/LevelHolder/LevelTest/Friend
			var Player = %Player
			Player.look_at(Vector3(friend.global_position.x, Player.global_position.y, friend.global_position.z), Vector3.UP)
			friend.look_at(Vector3(Player.global_position.x, friend.global_position.y, Player.global_position.z), Vector3.UP)
			
			GameManager.chat_dialogue.emit(1)

func _handle_special_area(_name: String) -> void:
	match _name:
		"stab", "Stab":
			GameManager.can_move = false
			GameManager.request_objective_completed.emit("reach the person")
		"reach telephone line":
			GameManager.request_objective_completed.emit("reach the telephone line")

func wake_up() -> void:
	GameManager.can_move = false
	cinamatics_player.play("wake up")
	blink_anim.play("blink")
	await get_tree().create_timer(8).timeout
	GameManager.can_move= true
	GameManager.handle_dialogue.emit(preload("res://dialogue/room#1.dialogue"), "start")
#endregion

#region usefull_funcitons
func _change_level(new_scene: PackedScene) -> void:
	var prev_level = level_holder.get_child(0)
	prev_level.queue_free()
	var new_level = new_scene.instantiate()
	level_holder.add_child(new_level)
	%Player.global_position = Vector3.ZERO

func _play_cinamatic(anim_name: String) -> void:
	if cinamatics_player.has_animation(anim_name):
		cinamatics_player.play(anim_name)

func _handle_dialogue(resourse, title):
	dialogue_balloon.dialogue_resource = resourse 
	dialogue_balloon.start_from_title = title
	dialogue_balloon.start()
#endregion
