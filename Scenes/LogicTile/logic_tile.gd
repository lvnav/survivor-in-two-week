class_name LogicTile extends Node2D

@onready var environmental_state: EnvironmentalState = $EnvironmentalState

var tiledata: TileData
var nodes: Dictionary = {}
var data: Dictionary = {}
var cell_position: Vector2i
	
func with_data(new_tiledata: TileData, new_cell_position: Vector2i) -> LogicTile:
	tiledata = new_tiledata
	position = EnvironmentalStateResolver.proc_world.environment.map_to_local(new_cell_position)

	return self
