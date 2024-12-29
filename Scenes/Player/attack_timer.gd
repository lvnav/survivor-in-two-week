extends Timer

const DEFAULT_WAIT_TIME: float = 1

func _on_player_attack_speed_modifier_has_changed(attack_speed_modifier: float) -> void:
	wait_time = wait_time / (DEFAULT_WAIT_TIME + (DEFAULT_WAIT_TIME * attack_speed_modifier / 100))
