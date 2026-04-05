extends CharacterBody3D

# Main
const SPEED: float = 2.5
const GRAVITY: float = -9.8
const JUMP_VELOCITY: float = 4.5
const SENSITIVITY: float = 0.004

# View Bobbing
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.04
var t_bob: float = 0.0

@onready var camera_holder: Node3D = $CameraHolder
@onready var main_camera: Camera3D = $CameraHolder/MainCamera
@onready var graphics: MeshInstance3D = $Graphics



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_holder.rotate_y(-event.relative.x * SENSITIVITY)
		graphics.rotate_y(-event.relative.x * SENSITIVITY)
		main_camera.rotate_x(-event.relative.y * SENSITIVITY)
		main_camera.rotation.x = clamp(main_camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))


func _physics_process(delta: float) -> void:
	if GameManager.can_move:
		handle_jump(delta)
		handle_movement()
		handle_head_bob(delta)
	move_and_slide()


func handle_jump(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0, GRAVITY, 0) * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func handle_movement() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_holder.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0


func handle_head_bob(delta: float) -> void:
	t_bob += delta * velocity.length() * float(is_on_floor())
	main_camera.transform.origin = _headbob(t_bob)


func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
