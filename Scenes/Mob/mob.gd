class_name Mob extends CharacterBody2D

const DEFAULT_SPEED = 100

@export var direction: Vector2 = Vector2(position)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var environmental_state: EnvironmentalState = $EnvironmentalState
@onready var environmental_state_sprite: EnvironmentalStateSprite = $EnvironmentalStateSprite
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

static var player_position: Vector2i

var is_touched_by_bullet: bool = false
var damage: int = 20
var life: int = 400
var is_burning: bool = false
var target: Player
signal die

func _ready() -> void:
	environmental_state_sprite.environmental_state = environmental_state

func _physics_process(delta: float) -> void:
	if direction.x < position.x:
		animated_sprite_2d.flip_h = true
	
	animated_sprite_2d.play()
	
	if label != null:
		label.text = str(position)

	if target != null:
		navigation_agent_2d.target_position = target.position
		var new_velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		_on_navigation_agent_2d_velocity_computed(new_velocity)
		move_and_slide()
	
func _on_screen_exited() -> void:
	queue_free()

func _on_player_position_change(new_position: Vector2i) -> void:
	player_position = new_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity * DEFAULT_SPEED

func _on_hit_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	EnvironmentalStateResolver.resolve(body, body_rid, self.environmental_state)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area is Bolt:
		life -= area.damage
	
	if life <= 0:
		die.emit()
		queue_free()
