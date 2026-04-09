extends Node

@export var ANIM_PLAYER: AnimationPlayer
@export var TOGGLE: bool = true

@export_category("MAIN DETAILS")
@export var ANIM_NAME: String = "open"
@export var INTERACT_TEXT: String = "open"
@export var OBJECTIVE: String = ""
@export var ONE_TIME: bool = false

@export_category("ONLY FOR TOGGLE")
@export var SECOND_ANIM_NAME: String = "close"
@export var SECOND_INTERACT_TEXT: String = "close"
@export var TOGGLE_OBJECTIVE: String = ""

var toggled: bool = false
var is_anim_playing: bool = false
var interact_text: String
var next_text: String
var one_time: bool = false

func _enter_tree() -> void:
	interact_text = INTERACT_TEXT
	ANIM_PLAYER.animation_finished.connect(_anim_finished)

func interact() -> void:
	if ONE_TIME and one_time: return
	one_time = true
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
		if anim == ANIM_NAME and OBJECTIVE != "": GameManager.request_objective_completed.emit(OBJECTIVE)
		elif anim == SECOND_ANIM_NAME and TOGGLE_OBJECTIVE != "": GameManager.request_objective_completed.emit(TOGGLE_OBJECTIVE)
		is_anim_playing = false
		interact_text = next_text
