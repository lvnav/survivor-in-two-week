class_name Mob extends Area2D

@export var direction: Vector2 = Vector2(position)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

var is_touched_by_bullet: bool = false
var damage: int = 20
var life: int = 400
var proc_gen_world_2: ProcGenWorld
static var player_position: Vector2i

signal die

func _physics_process(delta: float) -> void:
	if direction.x < position.x:
		animated_sprite_2d.flip_h = true
	
	animated_sprite_2d.play()
	
	if label != null:
		label.text = str(position)
		
	if player_position != null:
		position = position.move_toward(get_global_mouse_position(), delta * 100)

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_dmg_projectile"):
		var bolt: Bolt = area
		life -= bolt.damage
		
		if life <= 0:
			die.emit()
			queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		if body is TileMapLayer:
			var cell_coords = body.get_coords_for_body_rid(body_rid)
			if proc_gen_world_2 == null or !proc_gen_world_2.logic_tiles.has(cell_coords):
				return
				
			var environment = proc_gen_world_2.environment
			var tile = environment.get_cell_tile_data(cell_coords)
			var logic_tile: LogicTile = proc_gen_world_2.logic_tiles[cell_coords]
			logic_tile.data["is_burning"] = true


func _on_player_position_change(new_position: Vector2i) -> void:
	player_position = new_position
