extends Area2D

@export var direction: Vector2 = Vector2(position)
var is_touched_by_bullet: bool = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	position = position.move_toward(direction, delta * 100)

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_dmg_projectile"):
		is_touched_by_bullet = true
