extends Node

@warning_ignore("unused_signal") signal start_game
@warning_ignore("unused_signal") signal end_game
@warning_ignore("unused_signal") signal update_interact_label(text: String)
@warning_ignore("unused_signal") signal update_objective_label(text: String)

var can_move: bool = true
