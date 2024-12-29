extends CharacterBody2D

const DEFAULT_TOTAL_LIFE: int = 100
const BASE_SPEED: float = 100.0

@export var bolt: PackedScene
@export var bolts: Array
@export var total_life: int
@export var remaining_life: int

@onready var attack_timer: Timer = $AttackTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var player_state: String
var speed_modifier: float = 0.
var has_piercing_projectile: bool = false
var local_game_state: String

signal total_life_change
signal remaining_life_change
signal has_no_hp

func _ready() -> void:
	hide()
	_update_total_life(DEFAULT_TOTAL_LIFE)
	_update_remaining_life(DEFAULT_TOTAL_LIFE)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if local_game_state != "play":
		return
	_move()
	_aim()
	
func _move() -> void:
	var direction = Input.get_vector("user_move_left", "user_move_right", "user_move_up", "user_move_down")
	if (direction.x == 0 and direction.y == 0):
		player_state = "idle"
	else:
		player_state = "move"
	
	if direction.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
		
	velocity = direction * (BASE_SPEED + (BASE_SPEED * speed_modifier / 100))
	move_and_slide()
	
func _aim() -> void:
	ray_cast_2d.target_position = to_global(get_viewport().get_mouse_position())
	
func _shoot() -> void:
	var fired_bolt = bolt.instantiate()
	fired_bolt.position = position
	fired_bolt.direction = (ray_cast_2d.target_position).normalized()
	fired_bolt.shoot_origin = self
	bolts.append(fired_bolt)
	get_tree().current_scene.add_child(fired_bolt)

func _on_attack_timer_timeout() -> void:
	if local_game_state != "play":
		return
	_shoot()

func _update_total_life(new_total_life: int) -> void:
	total_life = new_total_life
	total_life_change.emit(total_life)

func _update_remaining_life(new_remaining_life: int) -> void:
	remaining_life = new_remaining_life
	remaining_life_change.emit(remaining_life)
	if (remaining_life <= 0):
		has_no_hp.emit()

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		_update_remaining_life(remaining_life - area.damage)

func upgrade(choice: Dictionary) -> void:
	if choice["type"] == "skill":
		if choice["skill_name"] == "piercing_projectile":
			has_piercing_projectile = true
		else:
			assert(false, "Please handle missing case")
	elif choice["type"] == "up_stat":
		if choice["stat"] == "damage":
			pass
		elif choice["stat"] == "move_speed":
			speed_modifier += choice["modifier_in_percent"]
		else:
			assert(false, "Please handle missing case")
	else:
		assert(false, "Please handle missing case")
	pass

func start(pos: Vector2):
	position = pos
	remaining_life = DEFAULT_TOTAL_LIFE
	show()
	$CollisionShape2D.disabled = false
	
func die():
	hide()
	$CollisionShape2D.disabled = true

func _on_game_state_change(game_state: String) -> void:
	local_game_state = game_state
