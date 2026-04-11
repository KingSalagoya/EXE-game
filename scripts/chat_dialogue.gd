extends Node

@onready var chat_ui: Control = $".."
@onready var msg_box: LineEdit = $"../VBoxContainer/msg box"

func _enter_tree() -> void:
	GameManager.chat_dialogue.connect(_decide_msg)

func _decide_msg(num) -> void:
	match num:
		1:
			chat_dialogue(first_dialogue)

func chat_dialogue(msg_array: Array):
	GameManager.can_move = false
	chat_ui.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	for msg in msg_array:
		match msg[0]:
			"R":
				await _send_msg("Rail", msg)
			"P":
				await _send_msg("Pete123", msg)
			"M":
				await _send_msg("Mia", msg)
	
	await get_tree().create_timer(1).timeout
	GameManager.can_move = true
	chat_ui.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _send_msg(usrnm: String, msg: String):
				var clean_msg = msg
				var colon_pos = msg.find(":")
				if colon_pos != -1:
					clean_msg = msg.substr(colon_pos + 1).strip_edges()
				chat_ui.usrnm = usrnm
				msg_box.text = clean_msg
				if usrnm == "Rail":
					await get_tree().create_timer(1).timeout
				chat_ui.send_msg()
				await get_tree().create_timer(1).timeout

var first_dialogue: Array = [
	"PETE123: bro you actually bought this game lmaooo",
	"RAIL: found it in a box. don't judge me",
	"PETE123: I'm judging you so hard right now",
	"PETE123: also... Rail? Is that actually you?",
	"RAIL: Pete Evans in the flesh. Or pixels I guess",
	"PETE123: this is insane. how long has it been",
	"RAIL: too long",
	"PETE123: you look terrible btw. your avatar does",
	"RAIL: thanks. you look like you haven't changed at all",
	"PETE123: lol same old Rail. hey I found a dagger in that shack over there. wolf head handle. go grab one, I'll wait",
	"RAIL_: you always did find the good stuff first",
	"PETE123: someone had to"
]
