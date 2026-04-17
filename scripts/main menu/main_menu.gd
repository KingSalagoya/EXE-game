extends Control

@onready var panels: MarginContainer = $Panels

const starting_level: PackedScene = preload("res://scenes/main.tscn")

func _ready() -> void:
	change_panel("Main")

func change_panel(panel_name: String) -> void:
	for i in panels.get_children():
		if i.name == panel_name: i.visible = true
		else: i.visible = false

func start_game() -> void:
	get_tree().change_scene_to_packed(starting_level)
	GameManager.start_game.emit()

func quit() -> void:
	get_tree().quit()
