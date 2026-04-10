extends CharacterBody3D

var player = null

const SPEED = 2

@export var hp: int = 10
@export var damage: int = 1

@export var player_path: NodePath

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var attaked: bool = false
var knockback_velocity := Vector3.ZERO
var knockback_force: float = 8.0
var attackable: bool = false

func apply_knockback(force: Vector3) -> void:
	knockback_velocity = force

func _ready() -> void:
	player_path = "/root/Main/GameViewport/SubViewport/GameEnviroment/Player"
	if player_path.is_empty():
		push_error("player_path is not set!")
		return
	player = get_node_or_null(player_path)
	if player == null:
		push_error("Could not find player at path: " + str(player_path))
		return

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if attackable:
		_handle_movement(delta)

	move_and_slide()

func _handle_movement(delta: float) -> void:
	if player == null:
		return

	if knockback_velocity.length() > 0.1:
		knockback_velocity = knockback_velocity.lerp(Vector3.ZERO, delta * 5.0)
		velocity = knockback_velocity
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	navigation_agent.set_target_position(player.global_position)

	if not navigation_agent.is_target_reachable():
		# print("Warning: Target not reachable. Falling back to direct movement.")
		var dir = (player.global_position - global_position)
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

	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)


func _on_attackable_area_body_entered(body: CharacterBody3D) -> void:
	if body == player:
		attackable = true

func _on_attackable_area_body_exited(body: CharacterBody3D) -> void:
	if body == player:
		attackable = false
