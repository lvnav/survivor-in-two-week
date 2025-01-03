class_name Player extends CharacterBody2D

var BoltPacked: PackedScene = preload("res://Scenes/Bolt/Bolt.tscn")

const DEFAULT_TOTAL_LIFE: int = 100
const BASE_SPEED: float = 500.0

@export var bolt: PackedScene
@export var bolts: Array[Bolt]
@export var total_life: int
@export var remaining_life: int

@onready var attack_timer: Timer = $AttackTimer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var dodge_timer: Timer = $DodgeTimer
@onready var release_dodge_timer: Timer = $ReleaseDodgeTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var hit_box_collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape
@onready var state_indicator: HBoxContainer = $StateIndicator
@onready var hit_box: Area2D = $HitBox
@onready var character_body_collision_shape: CollisionShape2D = $CharacterBodyCollisionShape
@onready var label: Label = $Label
@onready var environmental_state: EnvironmentalState = $EnvironmentalState
@onready var environmental_state_sprite: EnvironmentalStateSprite = $EnvironmentalStateSprite
@onready var sprite_2d: Sprite2D = $Sprite2D

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
var is_burning: bool = true
var bullet_mode: String = "burning"

signal total_life_change
signal remaining_life_change
signal has_no_hp
signal attack_speed_modifier_has_changed
signal shoot
signal position_change

func _ready() -> void:
	hide()
	camera_2d.make_current()
	
	set_total_life(DEFAULT_TOTAL_LIFE)
	set_remaining_life(DEFAULT_TOTAL_LIFE)
	environmental_state_sprite.environmental_state = environmental_state
	
func _physics_process(_delta: float) -> void:
	if local_game_state != "play":
		return
	
	label.text = str(position)
	position_change.emit(position)
	if (Input.is_action_just_pressed("burning_projectile")):
		bullet_mode = "burning"
	elif (Input.is_action_just_pressed("wet_projectile")):
		bullet_mode = "wet"
		pass
		
	_zoom()
	_move()
	_aim()
	
func _move() -> void:
	var direction: Vector2 = Input.get_vector("user_move_left", "user_move_right", "user_move_up", "user_move_down")
	if (direction.x == 0 and direction.y == 0):
		player_state = "idle"
	else:
		player_state = "move"
	
	if to_local(ray_cast_2d.target_position).x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	if (direction.x != 0 or direction.y != 0) and Input.is_action_just_pressed("dodge") and release_dodge_timer.is_stopped():
		dodge_timer.start()
		dodge_move_speed_boost = BASE_SPEED
		
	velocity = direction * (dodge_move_speed_boost + BASE_SPEED + (BASE_SPEED * move_speed_modifier / 100))
	move_and_slide()
	
func _aim() -> void:
	ray_cast_2d.target_position = get_local_mouse_position().normalized()
	
func _on_attack_timer_timeout() -> void:
	if local_game_state != "play":
		return
	shoot.emit(BoltPacked, get_angle_to(ray_cast_2d.target_position), position, self)

func _zoom() -> void:
	if (Input.is_action_just_pressed("zoom_in")):
		var zoom_val: float = camera_2d.zoom.x + .1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
		pass
	if (Input.is_action_just_pressed("zoom_out")):
		var zoom_val: float = camera_2d.zoom.x - .1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
		pass

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

func start(pos: Vector2) -> void:
	position = pos
	remaining_life = DEFAULT_TOTAL_LIFE
	show()
	hit_box_collision_shape.disabled = false
	
func die() -> void:
	hide()
	hit_box_collision_shape.disabled = true

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


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var mob: Mob = area.get_parent()
		set_remaining_life(remaining_life - mob.damage)

func _on_hit_box_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	EnvironmentalStateResolver.resolve(body, body_rid, self.environmental_state)
		
