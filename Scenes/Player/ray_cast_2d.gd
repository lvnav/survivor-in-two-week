extends RayCast2D

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	
	target_position = to_local(get_viewport().get_mouse_position())
	
	pass
