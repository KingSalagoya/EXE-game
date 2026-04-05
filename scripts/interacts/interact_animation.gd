extends Node

enum interact_type {animation, scene_change, wood}

@export var ANIM_PLAYER: AnimationPlayer
@export var TOGGLE: bool = true

@export_category("MAIN DETAILS")
@export var ANIM_NAME: String = "open"
@export var INTERACT_TEXT : String = "open"
@export var TRIGGERS_OBJECTIVE: bool = false
@export var INTERACT_TYPE: interact_type
@export var next_scene: PackedScene

@export_category("ONLY FOR TOGGLE")
@export var SECOND_ANIM_NAME: String = "close"
@export var SECOND_INTERACT_TEXT: String = "close"

var toggled: bool = false
var is_anim_playing: bool = false
var interact_text: String
var next_text: String

func _enter_tree() -> void:
	interact_text = INTERACT_TEXT
	if ANIM_PLAYER:
		ANIM_PLAYER.animation_finished.connect(_anim_finished)

func interact() -> void:
	if ANIM_PLAYER and not ANIM_PLAYER.is_playing() and INTERACT_TYPE == interact_type.animation:
		if TRIGGERS_OBJECTIVE and not toggled: GameManager.next_objective.emit(INTERACT_TEXT)
		
		if not TOGGLE: ANIM_PLAYER.play(ANIM_NAME)
		elif not is_anim_playing: toggle()
	
	elif INTERACT_TYPE == interact_type.scene_change and next_scene:
		var room = owner
		var parent = room.get_parent()
		var new_room = next_scene.instantiate()
		parent.remove_child(room)
		room.queue_free()
		parent.add_child(new_room)
		GameManager.next_objective.emit(INTERACT_TEXT)
	
	elif INTERACT_TYPE == interact_type.wood:
		GameManager.emit_signal("wood_collected")
		self.queue_free()

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
