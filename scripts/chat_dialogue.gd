extends Node

@onready var chat_ui: Control = $".."
@onready var msg_box: LineEdit = $"../VBoxContainer/msg box"

var msg_cache: String = ""

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
		await get_tree().create_timer(randf_range(0.5 , 3)).timeout
	
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
	
	msg_box.text = ""
	msg_cache = ""
	
	for i in range(clean_msg.length()):
		if usrnm == "Rail":
			msg_box.text += clean_msg[i]
			msg_box.set_caret_column(msg_box.text.length())
		else:
			msg_cache += clean_msg[i]
			
		await get_tree().create_timer(randf_range(0.05, 0.1)).timeout
		
	if usrnm == "Rail":
		await get_tree().create_timer(0.5).timeout
	else:
		msg_box.text = msg_cache
	
	chat_ui.send_msg()
	await get_tree().create_timer(1).timeout

var first_dialogue: Array = [
	"PETE: Hi",
	"RAIL: PETE? Are you PETE EVANS?",
	"PETE: Yes, how do u know?",
	"RAIL: I’m ARU RAIL. Can U remember? We were in the same class 17 years ago!",
	"PETE: ARU! Wow! After all this time! I missed you, man. Bro, where did u find this game?",
	"RAIL: I found it inside my cupboard. I didn’t even know what this game was until I played it. I miss good old days.",
	"PETE: Me too. BTW How are U? OMG. I miss oldtimes. So how are U?",
	"RAIL: Never been better.lol.",
	"PETE: Same here. BTW, you didn’t tell anyone my secret right?",
	# Suddenly everything starts to echo....
	"RAIL: N-no ... I didn’t. You can trust me.",
	"PETE: I know it. U R my best friend btw",
	"RAIL: That sounded a bit cheesy, ngl.",
	"PETE: lol. But u know i always been like that. You were the only one who actually listened to me. Tbh that is why I told you my secret.",
	"RAIL: Uh ... yeah ... um ... BTW, that is a nice dagger you have. The one with the wolf head. Where did you get it, dude?",
	"PETE: Oh, I found it in a shack nearby. Bro, the good thing about this game? There is loot everywhere.",
	"RAIL: I also want a dagger like that. Is there anymore?",
	"PETE: Yes, in the shack. Go get it. I’ll wait."
]
