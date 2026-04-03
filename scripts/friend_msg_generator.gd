extends Control

var friend_usrnm: String = "Pete123"

@onready var chat_history: TextEdit = $"../chat history"

func generate_friend_msg(sent_msg) -> void:
	if "hi" in sent_msg:
		await get_tree().create_timer(1).timeout
		var friend_msg: String = "hello!"
		chat_history.text += friend_usrnm + ": " + friend_msg + "\n"
		chat_history.set_caret_line(chat_history.get_line_count() - 1)
