extends Node

@onready var footsteps_holder: Node = $Footsteps_Holder

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@export var music_clips: Node
@export var one_shots: Node
@export var audio_one_shot_scene: PackedScene
@export var audio_one_shot_clips: Dictionary[String, AudioStream]
@export var footsteps_clips: Dictionary[String, AudioStream]

func _ready() -> void:
	activate_music()

func play_music(audio_name:String, from_position: float = 0.0, restart: bool = false) -> void:
	if !restart and active_music_stream and active_music_stream.name == audio_name:
		return

	active_music_stream = music_clips.get_node(audio_name)
	active_music_stream.bus = "music"
	active_music_stream.play(from_position)

func handle_music_pause(audio_name: String, state: bool) -> void:
	active_music_stream = music_clips.get_node(audio_name)
	active_music_stream.stream_paused = state

func activate_music() -> void:
	for child in music_clips.get_children():
		if child is AudioStreamPlayer:
			play_music(child.name)
			handle_music_pause(child.name, true)

func play_audio_one_shot(audio_name: String, pos: Vector3 = Vector3.ZERO, volume_db: float = 0.0, from_position: float = 0.0) -> AudioOneShot:
	if audio_one_shot_clips.has(audio_name) == false: return
	var audio_one_shot: AudioOneShot = audio_one_shot_scene.instantiate()
	audio_one_shot.global_pos = pos
	audio_one_shot.stream = audio_one_shot_clips.get(audio_name)
	audio_one_shot.bus = "sfx"
	audio_one_shot.volume_db = volume_db
	audio_one_shot.from_position = from_position
	
	one_shots.add_child(audio_one_shot)
	return audio_one_shot

#region footsteps

func change_footsteps(new_footsteps: String, volume_db: float = 10.0) -> void:
	for child in footsteps_holder.get_children():
		child.queue_free()
		
	if footsteps_clips.has(new_footsteps) == false: return
	
	var new_footsteps_audio = AudioStreamPlayer.new()
	new_footsteps_audio.stream = footsteps_clips.get(new_footsteps)
	new_footsteps_audio.bus = "sfx"
	new_footsteps_audio.volume_db = volume_db
	
	footsteps_holder.add_child(new_footsteps_audio)
	
	new_footsteps_audio.play()

func toggle_footsteps_pause(state: bool) -> void:
	for child in footsteps_holder.get_children():
		if child is AudioStreamPlayer and not child.is_queued_for_deletion():
			if not state and not child.playing:
				child.play()
			child.stream_paused = state

#endregion
