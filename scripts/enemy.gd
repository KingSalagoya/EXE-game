extends CharacterBody3D

var player = null

const SPEED = 3.5

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

	velocity = Vector3.ZERO

	navigation_agent.set_target_position(player.global_position)

	if not navigation_agent.is_target_reachable():
		move_and_slide()
		return

	if navigation_agent.is_navigation_finished():
		move_and_slide()
		return

	var next_nav_point = navigation_agent.get_next_path_position()

	velocity = (next_nav_point - global_position).normalized() * SPEED

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
