extends Node3D

var enemy = preload("res://scenes/enemy.tscn")

@onready var objectives: Node = $"../../../../../Objectives"
@onready var enemy_holder: Node3D = $Enemy_Holder

var spawn_enemies_count: int = 0

func _ready() -> void:
	GameManager.unlock_achievement.connect(unlock_achievement)

func _process(_delta: float) -> void:
	if objectives.current_objective_name == "kill enemies" and spawn_enemies_count <= 5:
		#await spawn_enemies()
		pass

func spawn_enemies() -> void:
	for i in range(5):
		var e = enemy.instantiate()
		enemy_holder.add_child(e)
		e.global_position = Vector3(14, 1.6637, 7)
		spawn_enemies_count += 1
		await get_tree().create_timer(1).timeout

func unlock_achievement(achievement: String) -> void:
	match achievement:
		"graveyard":
			$Boundaries/graveyard.queue_free()
		"village":
			$Boundaries/village.queue_free()
