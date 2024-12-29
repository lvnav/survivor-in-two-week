class_name Bolt extends Area2D

const DEFAULT_DAMAGE: int = 20

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300
var shoot_origin: Player
var damage: int = DEFAULT_DAMAGE

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var mob: Mob = area
		shoot_origin.leech(self, mob)
		if !shoot_origin.has_piercing_projectile:
			queue_free()
