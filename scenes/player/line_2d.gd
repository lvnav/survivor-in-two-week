extends Line2D
@onready var player: CharacterBody2D = $"../.."
@onready var ray_cast_2d: RayCast2D = $".."


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	set_point_position(0, player.position)
	set_point_position(1, ray_cast_2d.target_position)
	pass
