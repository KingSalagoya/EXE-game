extends Control

@onready var panels: MarginContainer = $Panels
@onready var main: Control = $Panels/Main
@onready var options: Control = $Panels/Options

const starting_level: PackedScene = preload("res://scenes/main.tscn")

var sfx_value: float
var music_value: float

func _ready() -> void:
	GameManager.handle_exit.connect(handle_exit)
	
	setup_audio_values()

func setup_audio_values() -> void:
	var music_bus_index = AudioServer.get_bus_index("music")
	sfx_value = AudioServer.get_bus_volume_db(music_bus_index)
	
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	music_value = AudioServer.get_bus_volume_db(sfx_bus_index)
	
	$Panels/Options/Options/Audio/sfx2/HSlider.value = sfx_value
	$Panels/Options/Options/Audio/music2/HSlider.value = music_value

func handle_audio_values() -> void:
	sfx_value = $Panels/Options/Options/Audio/sfx2/HSlider.value
	music_value = $Panels/Options/Options/Audio/music2/HSlider.value
	
	var music_bus_index = AudioServer.get_bus_index("music")
	AudioServer.set_bus_volume_db(music_bus_index, music_value)
	
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_volume_db(sfx_bus_index, sfx_value)
	
	print("Music: " , music_value , "   |   SFX: " , sfx_value)

func handle_exit() -> void:
	if visible:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		handle_audio_values()
	else:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _on_exit_pressed() -> void:
	handle_exit()
