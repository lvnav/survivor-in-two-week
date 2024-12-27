extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var spawns: Node2D = $Spawns
@onready var hud: Control = $HUD
@onready var root: Sprite2D = $".."

@export var enemy : PackedScene
@export var enemies : Array

const UP_CHOICE = [
	{
		"type": "up_stat",
		"stat": "damage",
		"modifier_in_percent": 10.
	},
	{
		"type": "up_stat",
		"stat": "move_speed",
		"modifier_in_percent": 20.
	},
	{
		"type": "skill",
		"skill_type": "range",
		"skill_name": "piercing_projectile"
	}
]

var score_value: int = 0
var need_up: bool

signal level_up

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	_move_mobs()
	if need_up:
		get_tree().paused = true
		level_up.emit(UP_CHOICE)

func _move_mobs() -> void: 
	for local_enemy in enemies:
		if is_instance_valid(local_enemy):
			local_enemy.direction = player.position

func _on_mob_spawn_timeout() -> void:
	_init_mob()

func _init_mob() -> void:
	if root.game_state != root.GAME_STATE_PLAY:
		return

	var new_enemy = enemy.instantiate()
	new_enemy.die.connect(self._on_enemy_die)
	var spawner_position: Node2D = spawns.get_child(randi_range(0, spawns.get_child_count()-1))
	new_enemy.position = spawner_position.position
	add_child(new_enemy)
	enemies.append(new_enemy)

func _on_enemy_die() -> void:
	score_value += 1
	if (score_value % 5 == 0):
		need_up = true

func _on_level_up_finished() -> void:
	need_up = false
	$HUD.clear_up_interface()
	get_tree().paused = false

func _up_button_pressed(choice: Dictionary) -> void:
	player.upgrade(choice)
	_on_level_up_finished()


func _on_game_state_change(game_state: String) -> void:
	if game_state == root.GAME_STATE_PLAY:
		new_game()
	if game_state == root.GAME_STATE_GAME_OVER:
		end_game()

func new_game() -> void:
	get_tree().paused = false
	score_value = 0
	get_tree().call_group("enemy", "queue_free")
	player.start(Vector2(0,0))

func end_game() -> void:
	player.die()
	get_tree().paused = true
