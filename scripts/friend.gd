extends CharacterBody3D

var target = null
var player = null

enum CHARACTER {friend}
@export var character: CHARACTER = CHARACTER.friend

@export var SPEED = 2

@export var hp: int = 10
@export var damage: int = 1

@export var target_path: NodePath
@export var target_path_str: String = "/root/Main/GameViewport/SubViewport/GameEnviroment/LevelHolder/LevelTest/Enemy_Holder/Enemy"

@export var player_path: NodePath
@export var player_path_str: String = "/root/Main/GameViewport/SubViewport/GameEnviroment/Player"

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var HitBox: hit_box = $hit_box

var attaked: bool = false
var knockback_velocity := Vector3.ZERO
var knockback_force: float = 8.0
var chasable: bool = false

func apply_knockback(force: Vector3) -> void:
	knockback_velocity = force

func _ready() -> void:
	target_path = target_path_str
	if target_path.is_empty():
		push_error("enemy_path is not set!")
		return
	target = get_node_or_null(target_path)
	if target == null:
		push_error("Could not find enemy at path: " + str(target_path))
		return


	player_path = player_path_str
	if player_path.is_empty():
		push_error("enemy_path is not set!")
		return
	player = get_node_or_null(player_path)
	if player == null:
		push_error("Could not find enemy at path: " + str(player_path))
		return
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if chasable:
		_handle_movement(delta)

	move_and_slide()

func _handle_movement(delta: float) -> void:
	if target == null:
		return

	if knockback_velocity.length() > 0.1:
		knockback_velocity = knockback_velocity.lerp(Vector3.ZERO, delta * 5.0)
		velocity = knockback_velocity
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	navigation_agent.set_target_position(target.global_position)

	if not navigation_agent.is_target_reachable():
		# print("Warning: Target not reachable. Falling back to direct movement.")
		var dir = (target.global_position - global_position)
		dir.y = 0
		if dir.length() > 0.1:
			dir = dir.normalized()
			velocity.x = dir.x * SPEED
			velocity.z = dir.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0
		move_and_slide()
		return

	if navigation_agent.is_navigation_finished():
		move_and_slide()
		return

	var next_nav_point = navigation_agent.get_next_path_position()
	
	# Only change the horizontal velocity to avoid overwriting gravity
	var direction = (next_nav_point - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)


func _on_attackable_area_body_entered(body: CharacterBody3D) -> void:
	if body == target:
		chasable = true

func _on_attackable_area_body_exited(body: CharacterBody3D) -> void:
	if body == target:
		chasable = false

func _on_hit_box_body_entered(body: CharacterBody3D) -> void:
	if body == player:
		HitBox.attackable = false

func _on_hit_box_body_exited(body: CharacterBody3D) -> void:
	if body == player:
		HitBox.attackable = true
