extends AnimationPlayer

var pos: Vector3 = Vector3.ZERO

func play_sfx(audio_name: String, volume_db: float = 0.0, from_position: float = 0.0) -> void:
	var audio = AudioManager.play_audio_one_shot(audio_name, pos, volume_db, from_position)
