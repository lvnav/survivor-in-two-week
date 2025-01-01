class_name ProcGenWorld extends Node2D

@export var noise_height_text: NoiseTexture2D
@export var noise_tree_text: NoiseTexture2D

@onready var water: TileMapLayer = $Water
@onready var ground_1: TileMapLayer = $Ground1
@onready var ground_2: TileMapLayer = $Ground2
@onready var cliff: TileMapLayer = $Cliff
@onready var environment: TileMapLayer = $Environment
@onready var level: Level = $".."
@export var logic_tile : PackedScene

var logic_tiles : Dictionary = {}

var noise: Noise
var tree_noise: Noise

var width: int = 100
var height: int = 100

var source_id: int = 0
var water_atlas: Vector2i = Vector2i(0, 1)
var land_atlas: Vector2i = Vector2i(0, 0)

var terrain_sand_int: int = 0
var sand_tiles: Array[Vector2i] = []

var grass_tiles: Array[Vector2i] = []
var terrain_grass_int: int = 1

var cliff_tiles: Array[Vector2i] = []
var terrain_cliff_int:int = 2

var grass_atlas: Array[Vector2i] = [
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(4,0),
	Vector2i(5,0),
]

var palm_tree_atlas: Array[Vector2i] = [Vector2i(12,2), Vector2i(15,2)]
var oak_tree_atlas: Vector2i = Vector2i(15,6)

func _ready() -> void:
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	EnvironmentalStateResolver.proc_world = self
	generate_world()
	var cliff_vectors = cliff.get_used_cells()
	for cliff_vector in cliff_vectors:
		ground_1.erase_cell(cliff_vector)
		ground_2.erase_cell(cliff_vector)
		water.erase_cell(cliff_vector)
	
func generate_world() -> void:
	for x: int in range(-width/2.0, width/2.0):
		for y:int in range(-height/2.0, height/2.0):
			var noise_val: float = noise.get_noise_2d(x,y)
			var tree_noise_val: float = tree_noise.get_noise_2d(x,y)
			if noise_val >= -0.2:
				if noise_val > 0 and noise_val < .17 and tree_noise_val > .85:
					var random_palm_tree_type: Vector2i = palm_tree_atlas.pick_random()
					
					var position = Vector2i(x,y)
					environment.set_cell(position, source_id, random_palm_tree_type)
					var tiledata = environment.get_cell_tile_data(position)
					
					var logic_tile: LogicTile = logic_tile.instantiate().with_data(
						tiledata,
						position
					)
					add_child(logic_tile)
					
					logic_tiles[position] = logic_tile
						
				if noise_val > .2:
					grass_tiles.append(Vector2i(x,y))
					if noise_val > .25:
						if noise_val < .3 and tree_noise_val > .85:
							environment.set_cell(Vector2i(x,y), source_id, oak_tree_atlas)
						var random_grass: Vector2i = grass_atlas.pick_random()
						ground_2.set_cell(Vector2i(x,y), source_id, random_grass)
						
					if noise_val > .3:
						cliff_tiles.append(Vector2i(x,y))

				sand_tiles.append(Vector2i(x,y))
			water.set_cell(Vector2i(x,y), source_id, water_atlas)
	
	water.set_cells_terrain_connect(sand_tiles, terrain_sand_int, 0)
	ground_1.set_cells_terrain_connect(grass_tiles, terrain_grass_int, 0)
	cliff.set_cells_terrain_connect(cliff_tiles, terrain_cliff_int, 0)
	
