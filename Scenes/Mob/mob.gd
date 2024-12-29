class_name Mob extends Area2D

@export var direction: Vector2 = Vector2(position)
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_touched_by_bullet: bool = false
var damage: int = 20
var life: int = 40

signal die

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if direction.x < position.x:
		sprite_2d.flip_h = true
	
	position = position.move_toward(direction, delta * 100)

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_dmg_projectile"):
		var bolt: Bolt = area
		life -= bolt.damage
		
		if life <= 0:
			die.emit()
			queue_free()
