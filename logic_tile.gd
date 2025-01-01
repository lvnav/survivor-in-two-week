class_name LogicTile extends Node

var tiledata: TileData
var nodes: Dictionary = {}
var data: Dictionary = {}
var cell_position: Vector2i
#var is_logic_tile: bool = true

func _ready() -> void:
	pass
	
func with_data(new_tiledata: TileData, new_cell_position: Vector2i) -> LogicTile:
	tiledata = new_tiledata
	cell_position = new_cell_position
	
	return self

func _process(delta: float) -> void:
	pass
