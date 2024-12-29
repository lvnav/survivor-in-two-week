extends Area2D

@export var direction: Vector2 = Vector2(position)
var is_touched_by_bullet: bool = false
var damage = 20

signal die

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if direction.x < position.x:
		$Sprite2D.flip_h = true
	
	position = position.move_toward(direction, delta * 100)

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_dmg_projectile"):
		die.emit()
		queue_free()