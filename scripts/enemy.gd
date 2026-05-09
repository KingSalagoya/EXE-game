class_name Enemy
extends CharacterBody3D

@export_enum("normal", "boss") var enemy_type : String = "normal"
@export_enum("idle", "chase", "attack") var action: String = "idle"

@export var health: int = 20
@export var speed: float = 5.0
@export var attack_range: float = 30.0

@onready var detect_area: Area3D = $DetectArea
@onready var animations: AnimationPlayer = $Graphics/AnimationPlayer
@onready var attack_cooldown_timer: Timer = $Timers/AttackCooldown

var target: Node3D
var attack_on_cooldown: bool = false

func _ready() -> void:
	detect_area.collision_layer = 0
	detect_area.collision_mask = 8
	detect_area.monitorable = false

func switch_action(_action: String) -> void:
	match _action:
		"idle":
			animations.play("zombie/zombie_idle", -1, randf_range(0.9, 1.1))
		"chase":
			animations.play("zombie/zombie_running", -1, randf_range(0.9, 1.1))
		"attack":
			attack_on_cooldown = true
			attack_cooldown_timer.start()
			animations.play("zombie/attack")

func _physics_process(_delta: float) -> void:
	_action_chase()
	move_and_slide()

func _action_chase() -> void:
	if action == "chase":
			if target == null: return
			look_at(target.global_position)
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * speed

			var distance = global_position.distance_to(target.global_position)
			if distance <= attack_range and not attack_on_cooldown:
				switch_action("attack")

	else:
		velocity = Vector3.ZERO

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()

func _on_player_detected(player: Player) -> void:
	if player == null: return
	target = player
	switch_action("chase")

func _on_player_left(player: Player) -> void:
	if player == null: return
	target = null
	switch_action("idle")

func _reset_attack_cooldown() -> void:
	attack_on_cooldown = false
	if target == null: switch_action("idle")
	else: switch_action("chase")
