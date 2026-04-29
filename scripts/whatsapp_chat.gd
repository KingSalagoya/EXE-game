extends Control

@onready var instruction_label: Label = $Instruction_Label
@onready var year_label: Label = $year_label
@onready var clouds: Sprite2D = $Clouds

func _ready() -> void:
	instruction_label.hide()
	year_label.hide()
	
	handle_year_label()

func _process(_delta: float) -> void:
	pass

func handle_year_label() -> void:
	await get_tree().create_timer(1).timeout
	year_label.show()
	await get_tree().create_timer(2).timeout
	year_label.hide()
	await get_tree().create_timer(1).timeout
	clouds.modulate.a = 80
	
