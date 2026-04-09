extends CharacterBody3D

var player = null

const SPEED = 2

@export var player_path: NodePath

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	print("ENEMY _READY() CALLED on ", name)
	# print("Tree: ", get_path())
	player_path = "/root/Main/GameViewport/SubViewport/GameEnviroment/Player"
	if player_path.is_empty():
		push_error("player_path is not set!")
		return
	player = get_node_or_null(player_path)
	if player == null:
		push_error("Could not find player at path: " + str(player_path))
		return
	print("Enemy ready - player found: ", player.name)

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Debug prints to see what's happening
	# print("Tracking player. Target reachable: ", navigation_agent.is_target_reachable(), ", Finished: ", navigation_agent.is_navigation_finished())

	navigation_agent.set_target_position(player.global_position)

	if not navigation_agent.is_target_reachable():
		# print("Warning: Target not reachable. Falling back to direct movement.")
		var direction = (player.global_position - global_position)
		direction.y = 0
		if direction.length() > 0.1:
			direction = direction.normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0
		move_and_slide()
		return

	if navigation_agent.is_navigation_finished():
		# print("Navigation finished")
		move_and_slide()
		return

	var next_nav_point = navigation_agent.get_next_path_position()
	
	# Only change the horizontal velocity to avoid overwriting gravity
	var direction = (next_nav_point - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
