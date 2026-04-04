extends Node

@export var ANIM_PLAYER: AnimationPlayer
@export var TOGGLE: bool = true

@export_category("MAIN DETAILS")
@export var ANIM_NAME: String = "open"
@export var INTERACT_TEXT : String = "open"

@export_category("ONLY FOR TOGGLE")
@export var SECOND_ANIM_NAME: String = "close"
@export var SECOND_INTERACT_TEXT: String = "close"

var toggled: bool = false
var is_anim_playing: bool = false
var interact_text: String
var next_text: String

func _enter_tree() -> void:
	interact_text = INTERACT_TEXT
	ANIM_PLAYER.animation_finished.connect(_anim_finished)

func interact() -> void:
	if ANIM_PLAYER and not ANIM_PLAYER.is_playing():
		if not TOGGLE: ANIM_PLAYER.play(ANIM_NAME)
		elif not is_anim_playing: toggle()

func toggle() -> void:
	is_anim_playing = true
	interact_text = ""
	toggled = !toggled
	if toggled:
		ANIM_PLAYER.play(ANIM_NAME)
		next_text = SECOND_INTERACT_TEXT
	else:
		ANIM_PLAYER.play(SECOND_ANIM_NAME)
		next_text = INTERACT_TEXT

func _anim_finished(anim) -> void:
	if anim == ANIM_NAME or anim == SECOND_ANIM_NAME:
		is_anim_playing = false
		interact_text = next_text
