class_name Player extends CharacterBody2D

const DEFAULT_TOTAL_LIFE: int = 100
const BASE_SPEED: float = 100.0

@export var bolt: PackedScene
@export var bolts: Array[Bolt]
@export var total_life: int
@export var remaining_life: int

@onready var attack_timer: Timer = $AttackTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dodge_timer: Timer = $DodgeTimer
@onready var release_dodge_timer: Timer = $ReleaseDodgeTimer

var local_game_state: String
var player_state: String

var attack_speed_modifier: float = 0.
var attack_damage_modifier: float = 0.
var move_speed_modifier: float = 0.
var leech_modifier: float = 0.
var roll_count: int = 0
var regen_on_closed_dodge_modifier: float = 0.
var dodge_move_speed_boost: float = 0.

var has_piercing_projectile: bool = false

signal total_life_change
signal remaining_life_change
signal has_no_hp
signal attack_speed_modifier_has_changed

func _ready() -> void:
	hide()
	set_total_life(DEFAULT_TOTAL_LIFE)
	set_remaining_life(DEFAULT_TOTAL_LIFE)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if local_game_state != "play":
		return
	_move()
	_aim()
	
func _move() -> void:
	var direction: Vector2 = Input.get_vector("user_move_left", "user_move_right", "user_move_up", "user_move_down")
	if (direction.x == 0 and direction.y == 0):
		player_state = "idle"
	else:
		player_state = "move"
	
	if direction.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	if (direction.x != 0 or direction.y != 0) and Input.is_action_just_pressed("dodge") and release_dodge_timer.is_stopped():
		print('cc')
		dodge_timer.start()
		dodge_move_speed_boost = BASE_SPEED
		
	velocity = direction * (dodge_move_speed_boost + BASE_SPEED + (BASE_SPEED * move_speed_modifier / 100))
	move_and_slide()
	
func _aim() -> void:
	ray_cast_2d.target_position = to_global(get_viewport().get_mouse_position())
	
func _shoot() -> void:
	var fired_bolt: Bolt = bolt.instantiate()
	fired_bolt.position = position
	fired_bolt.damage = fired_bolt.damage + int((fired_bolt.DEFAULT_DAMAGE * attack_damage_modifier / 100))
	fired_bolt.direction = (ray_cast_2d.target_position).normalized()
	fired_bolt.shoot_origin = self
	bolts.append(fired_bolt)
	get_tree().current_scene.add_child(fired_bolt)

func _on_attack_timer_timeout() -> void:
	if local_game_state != "play":
		return
	_shoot()

func set_total_life(new_total_life: int) -> void:
	total_life = new_total_life
	total_life_change.emit(total_life)

func set_remaining_life(new_remaining_life: int) -> void:
	remaining_life = new_remaining_life
	remaining_life_change.emit(remaining_life)
	if (remaining_life <= 0):
		has_no_hp.emit()
		
func set_attack_speed_modifier(new_attack_speed_modifier: float) -> void:
	attack_speed_modifier = new_attack_speed_modifier
	attack_speed_modifier_has_changed.emit(attack_speed_modifier)

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area is Mob:
		var mob: Mob = area
		set_remaining_life(remaining_life - mob.damage)

func start(pos: Vector2) -> void:
	position = pos
	remaining_life = DEFAULT_TOTAL_LIFE
	show()
	collision_shape_2d.disabled = false
	
func die() -> void:
	hide()
	collision_shape_2d.disabled = true

func _on_game_state_change(game_state: String) -> void:
	local_game_state = game_state

func leech(local_bolt: Bolt, mob: Mob) -> void:
	var damage: float = min(local_bolt.damage, mob.life)
	remaining_life = min(remaining_life + (damage * leech_modifier / 100), total_life)

func _on_dodge_timer_timeout() -> void:
	dodge_move_speed_boost = -50
	release_dodge_timer.start()
	dodge_timer.stop()

func _on_release_dodge_timer_timeout() -> void:
	dodge_move_speed_boost = 0
	release_dodge_timer.stop()
