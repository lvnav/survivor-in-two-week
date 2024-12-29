extends Node

const OPTIONS: Array[Dictionary] = [
	{
		"type": "stat",
		"stat": "attack_damage",
		"modifier": 10.,
		"rarity": 1
	},
	{
		"type": "stat",
		"stat": "attack_speed",
		"modifier": 10.,
		"rarity": 1
	},
	{
		"type": "stat",
		"stat": "move_speed",
		"modifier": 20.,
		"rarity": 1
	},
	{
		"type": "skill",
		"name": "piercing_projectile",
		"rarity": 3
	},
	{
		"type": "skill",
		"name": "roll",
		"rarity": 3
	},
	{
		"type": "skill",
		"name": "leech",
		"rarity": 2
	},
	{
		"type": "skill",
		"name": "regen_on_closed_dodge",
		"rarity": 2
	},
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func upgrade(player: Player, choice: Dictionary) -> void:
	if choice["type"] == "skill":
		if choice["skill_name"] == "piercing_projectile":
			player.has_piercing_projectile = true
		else:
			assert(false, "Please handle missing case")
	elif choice["type"] == "stat":
		if choice["stat"] == "damage":
			pass
		elif choice["stat"] == "move_speed":
			player.speed_modifier += choice["modifier_in_percent"]
		else:
			assert(false, "Please handle missing case")
	else:
		assert(false, "Please handle missing case")
	pass
