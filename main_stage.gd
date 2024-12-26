extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var enemies = Array()

@onready var player: CharacterBody2D = $Player
@onready var spawns: Node2D = $Spawns

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	
	var to_clean = []
	for enemy in enemies:
		if enemy.is_touched_by_bullet:
			remove_child(enemy)
	
		enemy.direction = player.position

func _on_mob_spawn_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var spawner_position: Node2D = spawns.get_child(randi_range(0, spawns.get_child_count()-1))
	
	enemy.position = spawner_position.position
	
	add_child(enemy)
	enemies.append(enemy)
