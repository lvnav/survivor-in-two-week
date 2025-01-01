class_name Bolt extends Area2D

@onready var environmental_state: EnvironmentalState = $EnvironmentalState
@onready var environmental_state_sprite: EnvironmentalStateSprite = $EnvironmentalStateSprite
@onready var sprite_2d: Sprite2D = $Sprite2D

const DEFAULT_DAMAGE: int = 20

var speed: float = 300
var shoot_origin: Player
var damage: int = DEFAULT_DAMAGE
var velocity: Vector2 = Vector2.RIGHT

func _ready() -> void:
	environmental_state_sprite.environmental_state = environmental_state
	
func _physics_process(delta: float) -> void:
	position += velocity * delta * speed
	
func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var mob: Mob = area.get_parent()
		shoot_origin.leech(self, mob)
		EnvironmentalStateResolver.priorizedPropagation(mob.environmental_state, self.environmental_state)
		if !shoot_origin.has_piercing_projectile:
			queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	EnvironmentalStateResolver.resolve(body, body_rid, self.environmental_state)
