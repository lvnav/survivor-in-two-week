class_name EnvironmentalStateSprite extends Sprite2D

@export var flame_sprite : CompressedTexture2D = preload("res://Assets/flame.png")
@export var wet_sprite: CompressedTexture2D = preload("res://Assets/wet.png")
@export var custom_scale: Vector2= Vector2(1, 1)

var environmental_state: EnvironmentalState 
	
func _ready() -> void:
	scale = custom_scale
	
func _process(_delta: float) -> void:
	if environmental_state.elemental_states["burning"]:
		texture = flame_sprite
	elif environmental_state.elemental_states["wet"]:
		texture = wet_sprite
