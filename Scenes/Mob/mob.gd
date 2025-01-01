class_name Mob extends Area2D

@export var direction: Vector2 = Vector2(position)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@onready var environmental_state: EnvironmentalState = $EnvironmentalState

static var player_position: Vector2i

var is_touched_by_bullet: bool = false
var damage: int = 20
var life: int = 400
var is_burning: bool = false

signal die

func _physics_process(delta: float) -> void:
	if direction.x < position.x:
		animated_sprite_2d.flip_h = true
	
	animated_sprite_2d.play()
	
	if label != null:
		label.text = str(position)
		
	if player_position != null:
		position = position.move_toward(get_global_mouse_position(), delta * 300)
	
func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_dmg_projectile"):
		var bolt: Bolt = area
		life -= bolt.damage
		
		if life <= 0:
			die.emit()
			queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		EnvironmentalStateResolver.resolve(body, body_rid, self.environmental_state)

func _on_player_position_change(new_position: Vector2i) -> void:
	player_position = new_position
