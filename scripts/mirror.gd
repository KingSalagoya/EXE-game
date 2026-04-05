extends MeshInstance3D

@onready var mirror_viewport: SubViewport = $MirrorViewport
@onready var mirror_camera: Camera3D = $MirrorViewport/MirrorCamera

var player_camera: Camera3D
var player_history: Array = []
var delay_sec: float = 1

func _ready() -> void:
	await get_tree().process_frame

	var player = get_node_or_null("/root/Main/GameEnviroment/Player")
	if player:
		player_camera = player.get_node_or_null("CameraHolder/MainCamera")

	var mat = get_active_material(0) as StandardMaterial3D
	if mat:
		mat.uv1_scale = Vector3(-1, 1, 1)
		mat.uv1_offset = Vector3(1, 0, 0)


func _process(_delta: float) -> void:
	if mirror_camera == null or player_camera == null:
		return

	var current_time = Time.get_ticks_msec() / 1000.0
	player_history.append([current_time, player_camera.global_position])

	# Remove old history
	while player_history.size() > 2 and player_history[1][0] < current_time - delay_sec:
		player_history.pop_front()

	var mirror_pos := mirror_camera.global_position
	var delayed_player_pos: Vector3

	if player_history.size() < 2:
		delayed_player_pos = player_history[0][1]
	else:
		# Interpolate between the two frames that straddle the target time
		var target_time = current_time - delay_sec
		var f1 = player_history[0]
		var f2 = player_history[1]
		
		var t1 = f1[0]
		var t2 = f2[0]
		var p1 = f1[1]
		var p2 = f2[1]
		
		var weight = clamp((target_time - t1) / (t2 - t1), 0.0, 1.0)
		delayed_player_pos = p1.lerp(p2, weight)

	# Direction from mirror camera to delayed player camera
	var dir_to_player := (delayed_player_pos - mirror_pos).normalized()

	# Rotate mirror camera to look back toward the player (mirror reflection)
	mirror_camera.look_at(mirror_pos + dir_to_player, Vector3.UP)
