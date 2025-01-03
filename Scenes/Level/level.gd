class_name Level extends Node2D

@onready var hud: Hud = $HUD
@onready var root: Root = $".."
@onready var up_handler: UpHandler = $UpHandler
@onready var player: Player = $ProcGenWorld2/Player
@onready var proc_gen_world_2: ProcGenWorld = $ProcGenWorld2
@onready var mob_spawn_timer: Timer = $MobSpawnTimer

@export var mob : PackedScene

var score_value: int = 0
var need_up: bool

signal level_up

func _ready() -> void:
	_init_mob()

func _process(_delta: float) -> void:
	if need_up or Input.is_action_just_pressed("debug_up"):
		get_tree().paused = true
		level_up.emit([up_handler.OPTIONS.pick_random(),up_handler.OPTIONS.pick_random(),up_handler.OPTIONS.pick_random()])

func _on_mob_spawn_timeout() -> void:
	_init_mob()
	mob_spawn_timer.wait_time = mob_spawn_timer.wait_time * .95

func _init_mob() -> void:
	if root.game_state != root.GAME_STATE_PLAY:
		return

	var spawn_position: Vector2 = find_spawn_position()
	var new_mob: Mob = mob.instantiate()

	new_mob.die.connect(self._on_mob_die)
	new_mob.visible = true
	new_mob.target = player
	new_mob.position = spawn_position
	new_mob.process_mode = Node.PROCESS_MODE_INHERIT
	add_child(new_mob)

func _on_mob_die() -> void:
	score_value += 1
	if (score_value % 5 == 0):
		need_up = true

func _on_level_up_finished() -> void:
	need_up = false
	hud.clear_up_interface()
	get_tree().paused = false

func _up_button_pressed(choice: Dictionary) -> void:
	up_handler.upgrade(player, choice)
	_on_level_up_finished()


func _on_game_state_change(game_state: String) -> void:
	if game_state == root.GAME_STATE_PLAY:
		new_game()
	if game_state == root.GAME_STATE_GAME_OVER:
		end_game()

func new_game() -> void:
	get_tree().paused = false
	score_value = 0
	get_tree().call_group("mob", "queue_free")
	player.start(Vector2(0,0))

func end_game() -> void:
	player.die()
	get_tree().paused = true

func _on_player_shoot(BoltPacked: PackedScene, direction: float, location: Vector2, shooter: Player) -> void:
	var spawned_bullet: Bolt = BoltPacked.instantiate()
	#if direction p
	spawned_bullet.rotation = direction + (3 * PI / 2)
	spawned_bullet.position = location
	spawned_bullet.velocity = spawned_bullet.velocity.rotated(direction)
	spawned_bullet.shoot_origin = shooter
	
	add_child(spawned_bullet)

	if shooter.bullet_mode == "wet":
		spawned_bullet.environmental_state.set_elemental_state("burning", false)
		spawned_bullet.environmental_state.set_elemental_state("wet", true)
	if shooter.bullet_mode == "burning":
		spawned_bullet.environmental_state.set_elemental_state("burning", true)
		spawned_bullet.environmental_state.set_elemental_state("wet", false)
	
	
func find_spawn_position() -> Vector2:
	var proc_world: ProcGenWorld = EnvironmentalStateResolver.proc_world
	var spawnable_positions: Array[Vector2i] = proc_world.ground_1.get_used_cells()
	spawnable_positions = spawnable_positions.duplicate()
	spawnable_positions.append_array(proc_world.ground_2.get_used_cells())
	
	var camera_size: Vector2 = get_viewport_rect().size * player.camera_2d.zoom 
	var camera_oversize: Vector2 = camera_size * 2
	var camera_rect: Rect2 = Rect2(player.camera_2d.get_screen_center_position() - camera_size / 2, camera_size)
	var camera_rect_oversize: Rect2 = Rect2(player.camera_2d.get_screen_center_position() - camera_oversize / 2, camera_oversize)
	
	var has_find: bool = false
	var spawn_position: Vector2
	while !has_find:
		var spawnable_pos: Vector2i = spawnable_positions.pick_random()
		var local_spawnable_pos: Vector2 = proc_world.ground_1.map_to_local(spawnable_pos)
		if !camera_rect.has_point(local_spawnable_pos) and camera_rect_oversize.has_point(local_spawnable_pos):
			spawn_position = proc_world.ground_1.map_to_local(spawnable_pos)
			has_find = true
	return spawn_position
