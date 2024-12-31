extends Node2D

@export var noise_height_text: NoiseTexture2D
@export var noise_tree_text: NoiseTexture2D

@onready var water: TileMapLayer = $Water
@onready var ground_1: TileMapLayer = $Ground1
@onready var ground_2: TileMapLayer = $Ground2
@onready var cliff: TileMapLayer = $Cliff
@onready var environment: TileMapLayer = $Environment

var noise: Noise
var tree_noise: Noise

var width: int = 100
var height: int = 100

var source_id: int = 0
var water_atlas: Vector2i = Vector2i(0, 1)
var land_atlas: Vector2i = Vector2i(0, 0)

var terrain_sand_int = 0
var sand_tiles = []

var grass_tiles = []
var terrain_grass_int = 1

var cliff_tiles = []
var terrain_cliff_int = 2

var grass_atlas: Array[Vector2i] = [
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(4,0),
	Vector2i(5,0),
]

var palm_tree_atlas = [Vector2i(12,2), Vector2i(15,2)]
var oak_tree_atlas = Vector2i(15,6)

func _ready() -> void:
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	generate_world()
	
func generate_world() -> void:
	var a = []
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val: float = noise.get_noise_2d(x,y)
			var tree_noise_val: float = tree_noise.get_noise_2d(x,y)
			
			a.append(tree_noise_val)
			if noise_val >= -0.2:
				if noise_val > 0 and noise_val < .17 and tree_noise_val > .85:
						environment.set_cell(Vector2i(x,y), source_id, palm_tree_atlas.pick_random())
				if noise_val > .2:
					grass_tiles.append(Vector2i(x,y))
					if noise_val > .25:
						if noise_val < .3 and tree_noise_val > .85:
							environment.set_cell(Vector2i(x,y), source_id, oak_tree_atlas)
						ground_2.set_cell(Vector2i(x,y), source_id, grass_atlas.pick_random())
					if noise_val > .3:
						cliff_tiles.append(Vector2i(x,y))

				sand_tiles.append(Vector2i(x,y))
			water.set_cell(Vector2i(x,y), source_id, water_atlas)
	
	print(a.min(), a.max())
	water.set_cells_terrain_connect(sand_tiles, terrain_sand_int, 0)
	ground_1.set_cells_terrain_connect(grass_tiles, terrain_grass_int, 0)
	cliff.set_cells_terrain_connect(cliff_tiles, terrain_cliff_int, 0)
