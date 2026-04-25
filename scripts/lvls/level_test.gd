extends Node3D

var enemy = preload("res://scenes/enemy.tscn")
var FRIEND = preload("res://scenes/friend.tscn")

@onready var objectives: Node = $"../../../../../Objectives"
@onready var enemy_holder: Node3D = $Enemy_Holder

var spawn_enemies_count: int = 0
var friend_spawned: bool = false

func _ready() -> void:
	GameManager.unlock_achievement.connect(unlock_achievement)
	GameManager.spawn_boss_enemy.connect(spawn_enemies)
	GameManager.spawn_friend.connect(spawn_friend)
	#spawn_friend()

func _process(_delta: float) -> void:
	if objectives.current_objective_name == "kill enemies" and spawn_enemies_count <= 5:
		#await spawn_enemies()
		pass
		
		#if %Player.hp <= 10 and friend_spawned == false
		#	spawn_friend()

func spawn_enemies() -> void:
	for i in range(1):
		var e = enemy.instantiate()
		enemy_holder.add_child(e)
		GameManager.update_player_count.emit(2)
		e.global_position = Vector3(9.222, 1.974, 18.00)
		e.character = e.CHARACTER.boss
		e.hp = 1000
		e.damage = 1
		e.knockback_force = 16.0
		spawn_enemies_count += 1
		await get_tree().create_timer(1).timeout

func spawn_friend() -> void:
	var friend_scene = FRIEND.instantiate()
	add_child(friend_scene)
	friend_scene.global_position = Vector3(0, 4, 0)
	friend_spawned = true

func unlock_achievement(achievement: String) -> void:
	match achievement:
		"forest":
			if $Boundaries/forest:
				$Boundaries/forest.queue_free()
		"graveyard":
			if $Boundaries/graveyard:
				$Boundaries/graveyard.queue_free()
