extends Line2D
@onready var player: CharacterBody2D = $"../.."
@onready var ray_cast_2d: RayCast2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_point_position(0, to_local(player.position))
	set_point_position(1, ray_cast_2d.target_position)
	pass
