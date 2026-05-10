class_name Player
extends CharacterBody3D

# Main
const SPEED: float = 5
const GRAVITY: float = -9.8
const JUMP_VELOCITY: float = 4.5
const SENSITIVITY: float = 0.004

@onready var camera_holder: Node3D = $CameraHolder
@onready var main_camera: Camera3D = $CameraHolder/MainCamera
@onready var graphics: MeshInstance3D = %Graphics
@onready var interactor: RayCast3D = $CameraHolder/MainCamera/Interactor
@onready var flashlight: SpotLight3D = $CameraHolder/MainCamera/flashlight
@onready var playeranimations: AnimationPlayer = %Graphics/hero/playeranimations
@onready var footsteps_detector: RayCast3D = $FootstepsDetector
@onready var upper_climb_check: RayCast3D = $CameraHolder/upper_climb_check
@onready var lower_climb_check: RayCast3D = $CameraHolder/lower_climb_check
@onready var sword: MeshInstance3D = $CameraHolder/Graphics/hero/rig/Skeleton3D/sword/sword


#Jumpscare Entities
@onready var under_water_scare: Node3D = $"../../VillageHouse6/door_frame/Pete"

@export var health: int = 40
@export var knockback_force: float = 8.0


var prev_ground
var can_use_flashlight: bool = false
var attack_on_cooldown: bool = false
var knockback_velocity := Vector3.ZERO

enum lock_types {NONE, MOVE, ROTATE}
var current_lock_type: lock_types = lock_types.NONE

#jumpscarelist
var pete: bool = false
var corpse: bool = false

func _enter_tree() -> void:
	GameManager.player = self
	GameManager.release_ending.connect(enable_flashlight)
	GameManager.paralize_coords.connect(paralize_coords)
	GameManager.unlock_sword.connect(_unlock_sword)
	GameManager.handle_torch.connect(handle_torch)

func _ready() -> void:
	flashlight.visible = false
	sword.visible = false


func _unhandled_input(event: InputEvent) -> void:
	_handle_rotation(event)
	_handle_attack(event)

func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_jump()
	_handle_gravity(delta)
	move_and_slide()



func _handle_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion and current_lock_type != lock_types.ROTATE:
		camera_holder.rotate_y(-event.relative.x * SENSITIVITY)
		main_camera.rotate_x(-event.relative.y * SENSITIVITY)
		main_camera.rotation.x = clamp(main_camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _handle_attack(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and sword.visible and not attack_on_cooldown:
		playeranimations.play("main-character/attack")

func _handle_movement() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_holder.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#movement
	if direction and current_lock_type == lock_types.NONE:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
#climb small objects
		if lower_climb_check.is_colliding():
			if not upper_climb_check.is_colliding():
				velocity.y = JUMP_VELOCITY/3
#visual effects
		if not attack_on_cooldown: playeranimations.play("main-character/running-backwards")
		AudioManager.toggle_footsteps_pause(false)
		_handle_footstep_sound()
#idle
	else:
		velocity.x = 0.0
		velocity.z = 0.0
#idle effects
		if not attack_on_cooldown: playeranimations.play("main-character/idle")
		AudioManager.toggle_footsteps_pause(true)

func _handle_jump() -> void:
	if current_lock_type != lock_types.NONE: return
	#if Input.is_action_just_pressed("jump") and is_on_floor() and GameManager.can_jump:
		#velocity.y = JUMP_VELOCITY

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0, GRAVITY, 0) * delta

func _unlock_sword() -> void:
	sword.visible = true

func take_damage(_damage: int) -> void:
	health -= _damage
	if health <= 0:
		get_tree().quit()

#region other

func _handle_footstep_sound() -> void:
	if footsteps_detector.is_colliding():
		var ground = footsteps_detector.get_collider()
		if ground == prev_ground: return
		prev_ground = footsteps_detector.get_collider()
		if ground != null:
			for groups in ground.get_groups():
				match groups:
					"grass": AudioManager.change_footsteps("grass", 20)
					"concrete": AudioManager.change_footsteps("concrete")
					"wood": AudioManager.change_footsteps("wood")

func enable_flashlight() -> void:
	GameManager.can_move = false
	GameManager.can_jump = false
	can_use_flashlight = true

func toggle_flashlight() -> void:
	AudioManager.play_audio_one_shot("switch off")
	GameManager.update_flashlight_counters.emit() # Counters Before Ending Increase

	await get_tree().create_timer(0.08).timeout
	flashlight.visible = true
	await get_tree().create_timer(3.0).timeout

	AudioManager.play_audio_one_shot("switch off")
	flashlight.visible = false

func paralize_coords(pos: Vector3, rot: Vector3) -> void:
	global_position = pos
	main_camera.global_rotation = rot

# this part is done  by Rush, don't touch without asking...

func handle_torch(state: bool) -> void:
	flashlight.visible = state

func toggle_torch() -> void:
	flashlight.visible = !flashlight.visible

func jumpscares() -> void:
	if GameManager.jumpscare_pete != null and main_camera.is_position_in_frustum(GameManager.jumpscare_pete.global_position):
		if GameManager.jumpscare_pete.visible == false or pete: return
		pete = true
		AudioManager.play_audio_one_shot("jumpscare l", Vector3.ZERO, 15)
		await get_tree().create_timer(0.4).timeout
		GameManager.jumpscare_pete.visible = false
		await get_tree().create_timer(1).timeout

		GameManager.request_objective_completed.emit("seek the underwater house")


#endregion


func _reset_attaack_cooldown() -> void:
	attack_on_cooldown = false
