extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@onready var clips: Node = $Clips

func play(audio_name: String, from_position: float = 0.0) -> void:
	active_music_stream = clips.get_node(audio_name) as AudioStreamPlayer
	active_music_stream.play(from_position)
