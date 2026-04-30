extends CharacterBody3D

# Main
var SPEED: float = 5
const GRAVITY: float = -9.8
const JUMP_VELOCITY: float = 4.5
const SENSITIVITY: float = 0.004

# View Bobbing
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.04
var t_bob: float = 0.0

@onready var camera_holder: Node3D = $CameraHolder
@onready var main_camera: Camera3D = $CameraHolder/MainCamera
@onready var graphics: MeshInstance3D = %Graphics
@onready var interactor: RayCast3D = $CameraHolder/MainCamera/Interactor
@onready var flashlight: SpotLight3D = $CameraHolder/MainCamera/flashlight

@onready var playeranimations: AnimationPlayer = %Graphics/hero/playeranimations

@onready var footsteps_detector: RayCast3D = $FootstepsDetector

@onready var upper_climb_check: RayCast3D = $CameraHolder/upper_climb_check
@onready var lower_climb_check: RayCast3D = $CameraHolder/lower_climb_check


@export var hp: int = 20
@export var damage:int = 10
@export var knockback_force: float = 8.0
@export var is_player: bool = true

# Player movement recording
var rec_count: int = 0
var play_count: int = 0
var can_record: bool = false
var can_play_recording: bool = false
var save_data: Dictionary = {0: [Vector3(0,0,0)]}
var load_data: Dictionary = Dictionary()
var recording_loaded: bool = false
var prev_ground

var can_use_flashlight: bool = false

var knockback_velocity := Vector3.ZERO

func _ready() -> void:
	flashlight.visible = false
	GameManager.release_ending.connect(enable_flashlight)
	GameManager.paralize_coords.connect(paralize_coords)
	pass
	#AudioManager.change_footsteps("concrete")
	GameManager.handle_torch.connect(handle_torch)

#region recording
func do_record():
	if can_record:
		rec_count += 1
		save_data[str(rec_count)] = [global_position]
	
	if Input.is_action_just_pressed("record"):
		var path = "res://recordings/rec1.json"
		var f = FileAccess.open(path, FileAccess.WRITE)
		
		print("Saving to: ", path)
		f.store_string(JSON.stringify(save_data))
		
		if f == null:
			push_error("Recording file not found. -player.gd :D")

func load_file():
	var path = "res://recordings/rec1.json"
	if path:
		var f = FileAccess.open(path, FileAccess.READ)
	
		var json = JSON.new()
		var error = json.parse(f.get_as_text())
	
		if error != OK:
			push_error("JSON Parse Error")
			return

		recording_loaded = true
		return json.data

func get_recording():
	if recording_loaded == false:
		load_file()
		recording_loaded = true
	play_count += 1
	var test = load_data.get(str(play_count))
	if test != null:
		global_position = str_to_var("Vector3" + test[0])

func handle_recording_movement():
	if Input.is_action_just_pressed("start recording"):
		if can_record:
			can_record = false
		else:
			can_record = true
	
	if Input.is_action_just_pressed("play recording"):
		if can_play_recording:
			can_play_recording = false
		else:
			can_play_recording = true
	
	if can_record:
		do_record()
	
	if can_play_recording:
		load_data = load_file()
		get_recording()
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not can_use_flashlight:
		camera_holder.rotate_y(-event.relative.x * SENSITIVITY)
		#graphics.rotate_y(-event.relative.x * SENSITIVITY)
		main_camera.rotate_x(-event.relative.y * SENSITIVITY)
		main_camera.rotation.x = clamp(main_camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
	elif event.is_action_pressed("attack") and not can_use_flashlight:
		if interactor.is_colliding():
			var target = interactor.get_collider()
			while target != null and target is Node:
				if target.is_in_group("Enemy"):
					var hb = null
					for child in target.get_children():
						if child is hurt_box:
							hb = child
							break
					if not hb:
						hb = target.get_node_or_null("hurt_box")
						
					if hb:
						var direction = (target.global_position - global_position).normalized()
						direction.y += 0.3
						direction = direction.normalized()
						hb.take_damage(damage, direction * knockback_force)
					break
				target = target.get_parent()
	if Input.is_action_just_pressed("flashlight") and can_use_flashlight:
		toggle_flashlight()
	
	if GameManager.can_toggle_torch:
		if Input.is_action_just_pressed("flashlight"):
			toggle_torch()

func _physics_process(delta: float) -> void:
	handle_recording_movement()
	handle_footstep_sound()
	
	if knockback_velocity.length() > 0.1:
		knockback_velocity = knockback_velocity.lerp(Vector3.ZERO, delta * 5.0)
		velocity = knockback_velocity
		if not is_on_floor():
			velocity += Vector3(0, GRAVITY, 0) * delta
		move_and_slide()
		return

	handle_jump(delta)

	if GameManager.can_move:
		handle_movement()
		handle_head_bob(delta)
		move_and_slide()
	else: AudioManager.toggle_footsteps_pause(true)

func handle_jump(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0, GRAVITY, 0) * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and GameManager.can_jump:
		velocity.y = JUMP_VELOCITY


func handle_movement() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_holder.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		playeranimations.play("main-character/running-backwards")

		if lower_climb_check.is_colliding():
			#print(lower_climb_check.get_collider().get_parent().name)
			if not upper_climb_check.is_colliding():
				velocity.y = JUMP_VELOCITY/3
		#if velocity.z > 0: playeranimations.play("main-character/running")
		#elif velocity.z < 0: playeranimations.play("main-character/running-backwards")
		AudioManager.toggle_footsteps_pause(false)
	else:
		playeranimations.play("main-character/idle")
		AudioManager.toggle_footsteps_pause(true)
		velocity.x = 0.0
		velocity.z = 0.0


#region other
func handle_head_bob(delta: float) -> void:
	t_bob += delta * velocity.length() * float(is_on_floor())
	main_camera.transform.origin = _headbob(t_bob)

func apply_knockback(force: Vector3) -> void:
	knockback_velocity = force

func _headbob(_time: float) -> Vector3:
	var pos = Vector3.ZERO
#	pos.y = sin(time * BOB_FREQ) * BOB_AMP
#	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func handle_footstep_sound() -> void:
	if footsteps_detector.is_colliding():
		var ground = footsteps_detector.get_collider()
		if ground == prev_ground: return
		prev_ground = footsteps_detector.get_collider()
		if ground != null:
			for groups in ground.get_groups():
				match groups:
					"grass": AudioManager.change_footsteps("grass", 30)
					"concrete": AudioManager.change_footsteps("concrete")
					"wood": AudioManager.change_footsteps("wood")

func enable_flashlight() -> void:
	GameManager.can_move = false
	GameManager.can_jump = false
	can_use_flashlight = true

func toggle_flashlight() -> void:
	GameManager.update_flashlight_counters.emit()
	await get_tree().create_timer(0.08).timeout
	flashlight.visible = true
	await get_tree().create_timer(3.0).timeout
	flashlight.visible = false


func paralize_coords(pos: Vector3, rot: Vector3) -> void:
	global_position = pos
	main_camera.global_rotation = rot

# this part is done  by Rush, don't touch without asking...

func handle_torch(state: bool) -> void:
	flashlight.visible = state

func toggle_torch() -> void:
	flashlight.visible = !flashlight.visible

#endregion
