extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	pass


func _on_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		print("cc")
		queue_free()
