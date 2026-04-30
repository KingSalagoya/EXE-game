extends Node3D

const WHATSAPP_CHAT = preload("uid://b520mxra380m5")
const ROOM_MAZE = preload("uid://cltj3uclqhk5g")

var wait_time: int = 5

func _ready() -> void:
	AudioManager.handle_music_pause("horror_theme_song", true)
	AudioManager.handle_music_pause("wind", true)
	AudioManager.handle_music_pause("wind", true)
	AudioManager.play_music("scary_music")

	GameManager.handle_torch.emit(false)
	$AnimationPlayer.play("instruction")
	GameManager.can_toggle_torch = true
	change_scene()

func change_scene() -> void:
	await get_tree().create_timer(wait_time).timeout
	GameManager.handle_torch.emit(false)
	GameManager.can_toggle_torch = false
	GameManager.change_scene.emit(ROOM_MAZE)
	#GameManager.add_scene.emit(WHATSAPP_CHAT, true)
