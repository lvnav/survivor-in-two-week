class_name UpHandler extends Node

# float modifiers are percent
const OPTIONS: Array[Dictionary] = [
	{
		"type": "stat",
		"stat": "attack_damage",
		"description": "Attack damage up",
		"modifier": 50.,
		"rarity": 1
	},
	{
		"type": "stat",
		"stat": "attack_speed",
		"description": "Attack speed up",
		"modifier": 10.,
		"rarity": 1
	},
	{
		"type": "stat",
		"stat": "move_speed",
		"description": "Move speed up",
		"modifier": 20.,
		"rarity": 1
	},
	{
		"type": "stat",
		"stat": "leech",
		"description": "Leech life",
		"modifier": 5.,
		"rarity": 2
	},
	{
		"type": "skill",
		"name": "piercing_projectile",
		"description": "Wow. Piercing projectile",
		"rarity": 3
	},
	#{
		#"type": "skill",
		#"name": "regen_on_closed_dodge",
		#"modifier": 3.,
		#"rarity": 2
	#},
]

func upgrade(player: Player, choice: Dictionary) -> void:
	if choice["type"] == "skill":
		match choice["name"]:
			"piercing_projectile":
				player.has_piercing_projectile = true
			_:
				assert(false, "Please handle missing case")
	elif choice["type"] == "stat":
		var modifier: float = choice["modifier"]
		
		match choice["stat"]:
			"attack_damage":
				player.attack_damage_modifier += choice["modifier"]
			"attack_speed":
				player.set_attack_speed_modifier(player.attack_speed_modifier + modifier)
			"move_speed":
				player.move_speed_modifier += choice["modifier"]
			"leech":
				player.leech_modifier += choice["modifier"]
			"regen_on_closed_dodge":
				player.regen_on_closed_dodge_modifier += choice["modifier"]
			_:
				assert(false, "Please handle missing case")
	else:
		assert(false, "Please handle missing case")
