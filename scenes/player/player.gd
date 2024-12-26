extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var bolt : PackedScene
@export var bolts : Array
@onready var attack_timer: Timer = $AttackTimer

const SPEED = 100.0
var player_state

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("user_move_left", "user_move_right", "user_move_up", "user_move_down")
	
	if (direction.x == 0 and direction.y == 0):
		player_state = "idle"
	else:
		player_state = "move"
	
	velocity = direction * SPEED
	
	move_and_slide()
	
	_aim()
	

func _aim() -> void:
	ray_cast_2d.target_position = to_global(get_viewport().get_mouse_position())
	
func _shoot() -> void:
	var fired_bolt = bolt.instantiate()
	fired_bolt.position = to_global(position)
	fired_bolt.direction = (ray_cast_2d.target_position).normalized()
	bolts.append(fired_bolt)
	get_tree().current_scene.add_child(fired_bolt)

func _on_attack_timer_timeout() -> void:
	_shoot()
