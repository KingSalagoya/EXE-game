extends Control

@onready var msg_box: LineEdit = $"msg box"
@onready var chat_history: TextEdit = $"chat history"

var msg: String
var usrnm: String = "RAIL"

signal msg_sent

func _ready() -> void:
	msg_sent.connect($"Friend Msg Generator".generate_friend_msg)

func _process(_delta: float) -> void:
	send_msg()

func send_msg() -> void:
	if Input.is_action_just_pressed("Enter") and msg_box.text != "":
		msg = usrnm + ": " + str(msg_box.text)
		chat_history.text += msg + "\n"
		chat_history.set_caret_line(chat_history.get_line_count() - 1)
		msg_sent.emit(msg_box.text)
		msg_box.text = ""
