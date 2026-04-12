extends Control

var friend_usrnm: String = "Pete123"

@onready var chat_history: TextEdit = $"../VBoxContainer/chat history"

func generate_friend_msg(sent_msg: String) -> void:
	#var lower_msg = sent_msg.to_lower()
	var friend_msg: String = ""
	var msg_cache: Array = []
	var cleaned_msg: String = sent_msg.to_lower().strip_edges()
	
	match cleaned_msg:
		"hi", "hello", "hey":
			msg_cache = ["hello!", "hi!", "hey bud...", "yoo! what's up"]
		"how are you", "hru", "how r u", "how are u":
			msg_cache = ["im good, wbu?", "not bad", "good, ig", "fine, u?"]
		"what's up", "whats up", "sup":
			msg_cache = ["not much, just chilling", "hanging out...", "just having some fun", "nothing interesting, u?"]
		"good", "great", "fine", "okay", "ok":
			msg_cache = ["nice", "nc", "fine", "nc nc", "great"]
		"lol", "lmao", "haha":
			msg_cache = ["lol yeah", "lol", ":D", ":)"]
		"yes", "yeah", "yep", "yup":
			msg_cache = ["cool", "yesh...", "nc"]
		"no", "nah", "nope":
			msg_cache = ["oh ok", "gotcha", "ok ok", "nvm"]
		"bye", "cya", "gtg":
			msg_cache = ["cya!..", "ok bye then...", "see ya...", "ok bye, come back soon..."]
		_:
			# For partial matches in case exact match fails, we can either do a quick fallback or just go straight to gibberish.
			# Let's keep it simple and clean as requested, defaulting to gibberish.
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
