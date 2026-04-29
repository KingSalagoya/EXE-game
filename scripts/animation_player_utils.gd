extends AnimationPlayer

@onready var cinematics_player: AnimationPlayer
var pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	#print("Available animations: ", self.get_animation_list())
	#cinamatics_player.play("play_computer")
	#play_with_temp_length("play_computer", 5, true)
	pass

func play_sfx(audio_name: String, volume_db: float = 0.0, from_position: float = 0.0) -> void:
	var audio = AudioManager.play_audio_one_shot(audio_name, pos, volume_db, from_position)


func play_with_temp_length(anim_name: String, length: float, forward: bool):
	var anim = self.get_animation(anim_name)
	var original_length: float = anim.length
	anim.length = length
	if forward:
		self.play(anim_name)
	else:
		self.play_backwards(anim_name)
	print("playing: " + anim_name)
	await self.animation_finished
	print("played: " + anim_name)
	anim.length = original_length


func release_ending() -> void:
	GameManager.release_ending.emit()
