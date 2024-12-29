class_name Bolt extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300
var shoot_origin: Player

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if !shoot_origin.has_piercing_projectile:
		if area.is_in_group("enemy"):
			queue_free()
