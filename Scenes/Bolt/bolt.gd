class_name Bolt extends Area2D

const DEFAULT_DAMAGE: int = 20

var speed: float = 300
var shoot_origin: Player
var damage: int = DEFAULT_DAMAGE

var velocity: Vector2 = Vector2.RIGHT

func _physics_process(delta):
	position += velocity * delta * speed
	
func _on_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		var mob = body
		#shoot_origin.leech(self, mob)
	#if !shoot_origin.has_piercing_projectile:
		#queue_free()
