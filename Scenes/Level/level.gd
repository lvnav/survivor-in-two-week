class_name Level extends Node2D

@onready var spawns: Node2D = $Spawns
@onready var hud: Hud = $HUD
@onready var root: Root = $".."
@onready var up_handler: UpHandler = $UpHandler
@onready var player: Player = $ProcGenWorld2/Player

@export var mob : PackedScene
@export var mobs : Array[Mob]

var score_value: int = 0
var need_up: bool

signal level_up

func _process(_delta: float) -> void:
	if need_up:
		get_tree().paused = true
		level_up.emit(up_handler.OPTIONS)

func _on_mob_spawn_timeout() -> void:
	_init_mob()

func _init_mob() -> void:
	if root.game_state != root.GAME_STATE_PLAY:
		return

	var new_mob: Mob = mob.instantiate()
	new_mob.die.connect(self._on_mob_die)
	var spawner_position: Node2D = spawns.get_child(randi_range(0, spawns.get_child_count()-1))
	new_mob.position = spawner_position.position
	add_child(new_mob)
	#mobs.append(new_mob)

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
	add_child(spawned_bullet)
	spawned_bullet.rotation = direction
	spawned_bullet.position = location
	spawned_bullet.velocity = spawned_bullet.velocity.rotated(direction)
	spawned_bullet.shoot_origin = shooter
	
	#var fired_bolt: Bolt = bolt.instantiate()
	#fired_bolt.position = position
	#fired_bolt.damage = fired_bolt.damage + int((fired_bolt.DEFAULT_DAMAGE * attack_damage_modifier / 100))
	#fired_bolt.direction = (ray_cast_2d.target_position).normalized()
	#fired_bolt.shoot_origin = self
	#bolts.append(fired_bolt)
	#get_tree().current_scene.add_child(fired_bolt)
