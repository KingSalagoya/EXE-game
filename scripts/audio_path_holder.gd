extends Node
class_name AudioPathHolder

@export var door_open: AudioStream
@export var door_close: AudioStream

@export var stab: AudioStream

@export var hallway_footsteps: AudioStream

@export var wake_up: AudioStream

@export var yawn: AudioStream

var sounds := {}

func _ready() -> void:
	sounds = {
		"door_open": door_open,
		"door_close": door_close,
		"stab": stab,
		"hallway_footsteps": hallway_footsteps,
		"wake_up": wake_up,
		"yawn": yawn
	}

func play_one_shot(audio_name: String):
	print("PLAY CALLED:", audio_name)
	print(sounds[audio_name])
	AudioManager.play_audio_one_shot(sounds[audio_name])
	if sounds.has(audio_name):
		AudioManager.play_audio_one_shot(sounds[audio_name])
	else:
		push_warning("Sound not found: " + audio_name)
