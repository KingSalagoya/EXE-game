extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@export var music_clips: Node
@export var one_shots: Node
@export var audio_one_shot_scene: PackedScene
@export var audio_one_shot_clips: Dictionary[String, AudioStream]

func play_music(audio_name:String, from_position: float = 0.0, restart: bool = false) -> void:
	if !restart and active_music_stream and active_music_stream.name == audio_name:
		return

	active_music_stream = music_clips.get_node(audio_name)
	active_music_stream.play(from_position)

func play_audio_one_shot(audio_name: String, pos: Vector3 = Vector3.ZERO, volume_db: float = 0.0, from_position: float = 0.0) -> AudioOneShot:
	if audio_one_shot_clips.has(audio_name) == false: return
	var audio_one_shot: AudioOneShot = audio_one_shot_scene.instantiate()
	audio_one_shot.global_pos = pos
	audio_one_shot.stream = audio_one_shot_clips.get(audio_name)
	audio_one_shot.volume_db = volume_db
	audio_one_shot.from_position = from_position
	
	one_shots.add_child(audio_one_shot)
	return audio_one_shot
