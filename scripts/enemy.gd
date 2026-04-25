extends CharacterBody3D

var target = null

enum CHARACTER {enemy, boss}
@export var character: CHARACTER = CHARACTER.enemy

@export var SPEED := 2.0

@export var hp: int = 10
@export var damage: int = 1

@export var target_path: NodePath
@export var target_path_str: String = "/root/Main/GameViewport/SubViewport/GameEnviroment/Player"

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $skeleton/AnimationPlayer


#var attaked: bool = false
var knockback_velocity := Vector3.ZERO
var knockback_force: float = 8.0
var attackable: bool = false
var animation_multiplier: float

func apply_knockback(force: Vector3) -> void:
	knockback_velocity = force

func _ready() -> void:
	animation_multiplier = randf_range(0.8, 1.2)
	target_path = target_path_str
	if target_path.is_empty():
		push_error("player_path is not set!")
		return
	target = get_node_or_null(target_path)
	if target == null:
		push_error("Could not find player at path: " + str(target_path))
		return
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if attackable:
		_handle_movement(delta)
	else: animation_player.play("zombie/zombie_idle", -1, animation_multiplier)
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
	look_at(target.global_position)

	if not navigation_agent.is_target_reachable():
		# print("Warning: Target not reachable. Falling back to direct movement.")
		var dir = (target.global_position - global_position)
		dir.y = 0
		if dir.length() > 0.1:
			dir = dir.normalized()
			animation_player.play("zombie/zombie_running")
			velocity.x = dir.x * SPEED
			velocity.z = dir.z * SPEED
		else:
			animation_player.play("zombie/zombie_idle")
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
		attackable = true

func _on_attackable_area_body_exited(body: CharacterBody3D) -> void:
	if body == target:
		attackable = false
