extends Node3D

var enemy = preload("res://scenes/enemy.tscn")
var FRIEND = preload("res://scenes/friend.tscn")

@onready var objectives: Node = $"../../../../../Objectives"
@onready var enemy_holder: Node3D = $Enemy_Holder

var spawn_enemies_count: int = 0
var friend_spawned: bool = false

func _ready() -> void:
	GameManager.can_jump = true
	
	GameManager.unlock_achievement.connect(unlock_achievement)
	GameManager.spawn_boss_enemy.connect(spawn_enemies)
	GameManager.spawn_friend.connect(spawn_friend)
	#spawn_friend()
	
	AudioManager.handle_music_pause("wind", false)
	AudioManager.handle_music_pause("horror_theme_song", false)
	
	#await get_tree().create_timer(1).timeout
	#GameManager.unlock_achievement.emit("forest")
	#await get_tree().create_timer(1).timeout
	GameManager.unlock_achievement.emit("graveyard")

func _process(_delta: float) -> void:
	if objectives.current_objective_name == "kill enemies" and spawn_enemies_count <= 5:
		#await spawn_enemies()
		pass
		
		#if %Player.hp <= 10 and friend_spawned == false
		#	spawn_friend()

func spawn_enemies() -> void:
	for i in range(1):
		var e = enemy.instantiate()
		GameManager.update_player_count.emit(2)
		e.global_position = Vector3(-39.677, -2.256, 22.989)
		e.character = e.CHARACTER.boss
		e.hp = 1000
		e.damage = 1
		e.knockback_force = 16.0
		spawn_enemies_count += 1
		enemy_holder.add_child(e)
		await get_tree().create_timer(1).timeout

func spawn_friend() -> void:
	await get_tree().create_timer(1).timeout
	var friend_scene = FRIEND.instantiate()
	friend_scene.global_position = Vector3(5.457, 3.598, -66.2)
	friend_spawned = true
	add_child(friend_scene)

func unlock_achievement(achievement: String) -> void:
	match achievement:
		"forest":
			if $Boundaries/forest:
				$Boundaries/forest.queue_free()
		"graveyard":
			if $Boundaries/graveyard:
				$Boundaries/graveyard.queue_free()
