extends Control

var friend_usrnm: String = "Pete123"

@onready var chat_history: TextEdit = $"../chat history"

func generate_friend_msg(sent_msg: String) -> void:
	var lower_msg = sent_msg.to_lower()
	var friend_msg: String = ""
	var msg_cache: Array = []
	
	if "hi" in lower_msg or "hello" in lower_msg or "hey" in lower_msg:
		msg_cache = ["hello!", "hi!", "hey bud...", "yoo! what's up"]
	elif "how are you" in lower_msg or "hru" in lower_msg or "how r u" in lower_msg:
		msg_cache = ["im good, wbu?", "not bad", "good, ig", "fine, u?"]
	elif "what's up" in lower_msg or "whats up" in lower_msg or "sup" in lower_msg:
		msg_cache = ["not much, just chilling", "hanging out...", "just having some fun", "nothing interesting, u?"]
	elif "good" in lower_msg or "great" in lower_msg or "fine" in lower_msg or "okay" in lower_msg or "ok" in lower_msg:
		msg_cache = ["nice", "nc", "fine", "nc nc", "great"]
	elif "lol" in lower_msg or "lmao" in lower_msg or "haha" in lower_msg:
		msg_cache = ["lol yeah", "lol", ":D", ":)"]
	elif "yes" in lower_msg or "yeah" in lower_msg or "yep" in lower_msg or "yup" in lower_msg:
		msg_cache = ["cool", "yesh...", "nc"]
	elif "no" in lower_msg or "nah" in lower_msg or "nope" in lower_msg:
		msg_cache = ["oh ok", "gotcha", "ok ok", "nvm"]
	elif "bye" in lower_msg or "cya" in lower_msg or "gtg" in lower_msg:
		msg_cache = ["cya!..", "ok bye then...", "see ya...", "ok bye, come back soon..."]
	else:
		msg_cache = [_generate_gibberish()]
	
	friend_msg = msg_cache.pick_random()
	
	# Simulates typing delay
	await get_tree().create_timer(randf_range(0.8, 2.0)).timeout
	chat_history.text += friend_usrnm + ": " + str(friend_msg) + "\n"
	chat_history.set_caret_line(chat_history.get_line_count() - 1)

func _generate_gibberish() -> String:
	var symbols: Array = ["!", "@", "#", "$", "%", "^", "&", "*", "?", "~", "+", "=", "-", "_", "/", "\\", "|", "<", ">"]
	var length: int = randi_range(3, 14)
	var result: String = ""
	for i in range(length):
		result += symbols.pick_random()
	return result
