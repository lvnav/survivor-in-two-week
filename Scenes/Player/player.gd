class_name Player extends CharacterBody2D

var BoltPacked: PackedScene = preload("res://Scenes/Bolt/Bolt.tscn")

const DEFAULT_TOTAL_LIFE: int = 100
const BASE_SPEED: float = 200.0

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
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skeleton_container: Node2D = $SkeletonContainer
@onready var camera_shake_timer: Timer = $CameraShakeTimer
@onready var self_heal_timer: Timer = $SelfHealTimer

var player_state: String

var attack_speed_modifier: float = 0.
var attack_damage_modifier: float = 0.
var move_speed_modifier: float = 0.
var leech_modifier: float = 0.
var roll_count: int = 0
var regen_on_closed_dodge_modifier: float = 0.
var dodge_move_speed_boost: float = 0.
var mob_applied_movement: Vector2
var has_piercing_projectile: bool = false
var is_burning: bool = true
var bullet_mode: String = "burning"

signal total_life_change
signal remaining_life_change
signal attack_speed_modifier_has_changed
signal shoot
signal position_change

func _ready() -> void:
	hide()
	camera_2d.make_current()
	GameState.game_state_change.connect(_on_game_state_change)
	
	set_total_life(DEFAULT_TOTAL_LIFE)
	set_remaining_life(DEFAULT_TOTAL_LIFE)
	environmental_state_sprite.environmental_state = environmental_state

func _process(_delta: float) -> void:
	if remaining_life <= 0:
		pass
	if environmental_state.elemental_states["wet"] and self_heal_timer.is_stopped():
		self_heal_timer.start()
	if environmental_state.elemental_states["burning"]:
		self_heal_timer.stop()
	
func _physics_process(_delta: float) -> void:
	if GameState.game_state != GameStateEnum.State.PLAY:
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
		animation_player.stop()
	else:
		player_state = "move"
		animation_player.play("walk")
	
	if to_local(ray_cast_2d.target_position).x < 0:
		skeleton_container.scale.x = -1
	else:
		skeleton_container.scale.x = 1
	
	if (direction.x != 0 or direction.y != 0) and Input.is_action_just_pressed("dodge") and release_dodge_timer.is_stopped():
		dodge_timer.start()
		dodge_move_speed_boost = BASE_SPEED
	
	velocity = mob_applied_movement + direction * (dodge_move_speed_boost + BASE_SPEED + (BASE_SPEED * move_speed_modifier / 100))
	mob_applied_movement = Vector2(0,0)
	move_and_slide()
	
func _aim() -> void:
	ray_cast_2d.target_position = get_local_mouse_position().normalized()
	
func _on_attack_timer_timeout() -> void:
	if GameState.game_state != GameStateEnum.State.PLAY:
		return
	shoot.emit(BoltPacked, get_angle_to(ray_cast_2d.target_position), position, self)

func _zoom() -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("zoom_in"):
		var zoom_val: float = camera_2d.zoom.x + .1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
		pass
	if OS.is_debug_build() and Input.is_action_just_pressed("zoom_out"):
		var zoom_val: float = camera_2d.zoom.x - .1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
		pass

func set_total_life(new_total_life: int) -> void:
	total_life = new_total_life
	total_life_change.emit(total_life)

func set_remaining_life(new_remaining_life: int) -> void:
	remaining_life = min(new_remaining_life, total_life)
	remaining_life_change.emit(remaining_life)
	if (remaining_life <= 0):
		GameState.end_game()
		
func set_attack_speed_modifier(new_attack_speed_modifier: float) -> void:
	attack_speed_modifier = new_attack_speed_modifier
	attack_speed_modifier_has_changed.emit(attack_speed_modifier)

func leech(local_bolt: Bolt, mob: Mob) -> void:
	var damage: float = min(local_bolt.damage, mob.life)
	remaining_life = int(remaining_life + (damage * leech_modifier / 100))

func _on_dodge_timer_timeout() -> void:
	dodge_move_speed_boost = -50
	release_dodge_timer.start()
	dodge_timer.stop()

func _on_release_dodge_timer_timeout() -> void:
	dodge_move_speed_boost = 0
	release_dodge_timer.stop()


func _on_hit_box_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("mob"):
		var mob: Mob = body
		mob_applied_movement += mob.velocity * 2
		set_remaining_life(remaining_life - mob.damage)
		
	EnvironmentalStateResolver.resolve(body, body_rid, self.environmental_state)
		
func _on_dot_timer_timeout() -> void:
	if environmental_state.elemental_states["burning"]:
		set_remaining_life(remaining_life - 5)

func _on_self_heal_timer_timeout() -> void:
	set_remaining_life(remaining_life + 2)

func _on_game_state_change(game_state: GameStateEnum.State) -> void:
	if game_state == GameStateEnum.State.GAME_OVER:
		die()
	if game_state == GameStateEnum.State.PLAY:
		start(Vector2(0,0))
	
func die() -> void:
	animation_player.play("die")
	environmental_state.reset()
	hit_box_collision_shape.disabled = true

func start(pos: Vector2) -> void:
	position = pos
	remaining_life = DEFAULT_TOTAL_LIFE
	show()
	hit_box_collision_shape.disabled = false
