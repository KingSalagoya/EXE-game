extends Control

@onready var panels: MarginContainer = $Panels
@onready var main: Control = $Panels/Main
@onready var options: Control = $Panels/Options
@onready var music_slider: HSlider = $Panels/Options/Options/Audio/music2/HSlider
@onready var sfx_slider: HSlider = $Panels/Options/Options/Audio/sfx2/HSlider


const starting_level = preload("uid://cc7wxhldse21p")


var sfx_value: float
var music_value: float

func _ready() -> void:
	change_panel("Main")
	
	setup_audio_values()

func setup_audio_values() -> void:
	sfx_value = sfx_slider.max_value
	music_value = music_slider.max_value
	
	var music_bus_index = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus_index, music_value)
	
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_volume_db(sfx_bus_index, sfx_value)
	
	sfx_slider.value = sfx_value
	music_slider.value = music_value

func handle_audio_values() -> void:
	sfx_value = sfx_slider.value
	music_value = music_slider.value
	
	var music_bus_index = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus_index, music_value)
	
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_volume_db(sfx_bus_index, sfx_value)
	
	print("Music: " , music_value , "   |   SFX: " , sfx_value)

func change_panel(panel_name: String) -> void:
	for i in panels.get_children():
		if i.name == panel_name: i.visible = true
		else: i.visible = false
	handle_audio_values()

func start_game() -> void:
	AudioManager.play_audio_one_shot("car")
	$AnimationPlayer.play("new_animation")
	await(get_tree().create_timer(8).timeout)
	get_tree().change_scene_to_packed(starting_level)
	GameManager.start_game.emit()

func quit() -> void:
	get_tree().quit()
