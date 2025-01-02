class_name LogicTile extends Node2D

@onready var environmental_state: EnvironmentalState = $EnvironmentalState
@onready var environmental_state_sprite: EnvironmentalStateSprite = $EnvironmentalStateSprite

var tiledata: TileData
var nodes: Dictionary = {}
var data: Dictionary = {}
var cell_position: Vector2i

func _ready() -> void:
	environmental_state_sprite.environmental_state = environmental_state
	
func with_data(new_tiledata: TileData, new_cell_position: Vector2i) -> LogicTile:
	tiledata = new_tiledata
	position = EnvironmentalStateResolver.proc_world.environment.map_to_local(new_cell_position)

	return self

func _on_environmental_state_elemental_state_consumed() -> void:
	if environmental_state.elemental_states["burning"]:
		EnvironmentalStateResolver.proc_world.environment.erase_cell(
			EnvironmentalStateResolver.proc_world.environment.local_to_map(position)
		)
		if !EnvironmentalStateResolver.proc_world.is_baking():
			EnvironmentalStateResolver.proc_world.bake_navigation_polygon()
		environmental_state_sprite.hide()
