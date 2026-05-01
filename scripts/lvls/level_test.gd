extends Node3D

var enemy = preload("res://scenes/enemy.tscn")
var FRIEND = preload("res://scenes/friend.tscn")

@onready var objectives: Node = $"../../../../../Objectives"
@onready var enemy_holder: Node3D = $Enemy_Holder
@onready var game_enviroment: Node3D = %GameEnviroment

var spawn_enemies_count: int = 0
var friend_spawned: bool = false

func _ready() -> void:
	GameManager.can_jump = true
	GameManager.corpse_seen.connect(seen_corpse)
	
	GameManager.unlock_achievement.connect(unlock_achievement)
	GameManager.spawn_boss_enemy.connect(spawn_enemies)
	GameManager.spawn_friend.connect(spawn_friend)
	#spawn_friend()
	
	AudioManager.handle_music_pause("wind", false)
	AudioManager.handle_music_pause("horror_theme_song", false)
	
	#await get_tree().create_timer(1).timeout
	#GameManager.unlock_achievement.emit("forest")
	await get_tree().create_timer(1).timeout
	#GameManager.unlock_achievement.emit("graveyard")
	GameManager.activate_sub_objective.emit(true)

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
		e.global_position = Vector3(39.11, 4, 103.6)
		e.character = e.CHARACTER.boss
		e.hp = 30
		e.scale = Vector3(2,2,2)
		e.damage = 1
		e.knockback_force = 16.0
		spawn_enemies_count += 1
		enemy_holder.add_child(e)
		await get_tree().create_timer(1).timeout

func spawn_friend() -> void:
	await get_tree().create_timer(1).timeout
	var friend_scene = FRIEND.instantiate()
	friend_scene.global_position = Vector3(-1.519, 0.079, -25.929)
	#(45.68, 4, 77.98)
	friend_spawned = true
	add_child(friend_scene)

func unlock_achievement(achievement: String) -> void:
	match achievement:
		"forest":
			if $Boundaries/forest:
				$Boundaries/forest.queue_free()
		"graveyard":
			if $Boundaries/graveyard:
				GameManager.graveyard_unlocked = true
				$Boundaries/graveyard.queue_free()
		"underwater":
			if $Boundaries/underwater:
				$Boundaries/underwater.queue_free()
		"bridge":
			if $Boundaries/bridge:
				$Boundaries/bridge.queue_free()

func seen_corpse() -> void:
	$NPC/Wizard2.visible = true
	GameManager.request_objective_completed.emit("check other side of the bridge")
	pass
