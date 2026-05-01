extends Node3D

const WHATSAPP_CHAT = preload("uid://b520mxra380m5")
const ROOM_MAZE = preload("uid://cltj3uclqhk5g")

var wait_time: float = 15

func _ready() -> void:
	AudioManager.stop_all_muisc()
	AudioManager.play_music("scary_music")

	GameManager.can_toggle_torch = true
	GameManager.handle_torch.emit(false)
	$AnimationPlayer.play("instruction")
	change_scene()

func change_scene() -> void:
	await get_tree().create_timer(wait_time).timeout
	GameManager.handle_torch.emit(false)
	GameManager.can_toggle_torch = false
	GameManager.change_scene.emit(ROOM_MAZE)
	#GameManager.add_scene.emit(WHATSAPP_CHAT, true)
