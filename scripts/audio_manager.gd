extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@onready var clips: Node = $Clips
@onready var one_shots: Node = $"One Shots"
@export var one_shot_scene: PackedScene

func play(audio_name: String, from_position: float = 0.0) -> void:
	active_music_stream = clips.get_node(audio_name) as AudioStreamPlayer
	active_music_stream.play(from_position)

func play_audio_one_shot(audio_stream: AudioStream, volume_db: float = 0.0, from_position: float = 0.0) -> AudioOneShot:
	var audio_one_shot = one_shot_scene.instantiate()
	audio_one_shot.stream = audio_stream
	audio_one_shot.volume_db = volume_db
	audio_one_shot.from_position = from_position
	
	return audio_one_shot
