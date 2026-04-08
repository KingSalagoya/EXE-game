extends Node

@warning_ignore("unused_signal") signal start_game
@warning_ignore("unused_signal") signal end_game

@warning_ignore("unused_signal") signal request_objective_completed(objective_name: String)
@warning_ignore("unused_signal") signal objective_completed(objective_name: String)
@warning_ignore("unused_signal") signal objective_collected(objective_name: String)
@warning_ignore("unused_signal") signal next_objective
@warning_ignore("unused_signal") signal wood_collected

@warning_ignore("unused_signal") signal update_interact_label(text: String)
@warning_ignore("unused_signal") signal update_objective_label(text: String)


@warning_ignore("unused_signal") signal handle_dialogue(resourse, title: String)
@warning_ignore("unused_signal") signal chat_dialogue(num: int)

var can_move: bool = true
var inventory:Dictionary [String, int] = {
	"wood": 0,
	"disk": 0,
	"walkie_talkie": 0
}
