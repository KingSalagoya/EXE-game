extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var instruction_label: Label = $Instruction_Label
@onready var year_label: Label = $year_label
@onready var clouds: Sprite2D = $Clouds
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const WHATSAPP_CHAT = preload("uid://b520mxra380m5")
const ROOM_1 = preload("uid://cb257hgwfgufx")
const WHATSAPP_CHAT_2 = preload("uid://d2dy8fqpj4dps")

var read_chat_1: bool = false
var can_change: bool = false

func on_ready() -> void:
	instruction_label.hide()
	year_label.hide()
	texture_rect.hide()
	
	play_animation()

func play_animation() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	texture_rect.show()
	await get_tree().create_timer(1).timeout
	year_label.show()
	await get_tree().create_timer(2).timeout
	animation_player.play("year_glitch")
	await animation_player.animation_finished
	year_label.hide()
	
	show_instruction()

func show_instruction() -> void:
	await  get_tree().create_timer(3).timeout
	instruction_label.show()
	can_change = true

func _unhandled_input(_event: InputEvent) -> void:
	if can_change:
		if Input.is_action_just_pressed("Enter"):
			if !read_chat_1:
				can_change = false
				texture_rect.texture = WHATSAPP_CHAT_2
				instruction_label.hide()
				show_instruction()
				read_chat_1 = true
			else:
				can_change = false
				GameManager.handle_dialogue.emit(ROOM_1, "whatsapp")
				await get_tree().create_timer(3).timeout
				GameManager.add_scene.emit(WHATSAPP_CHAT, false)
