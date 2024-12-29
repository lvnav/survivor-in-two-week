class_name Root extends Sprite2D

const GAME_STATE_START: StringName = "start"
const GAME_STATE_PLAY: StringName = "play"
const GAME_STATE_GAME_OVER: StringName = "game_over"

var game_state: String = GAME_STATE_START

signal game_state_change


func _process(_delta: float) -> void:
	pass

func _on_start_game() -> void:
	game_state = GAME_STATE_PLAY
	game_state_change.emit(game_state)

func _on_player_has_no_hp() -> void:
	game_state_change.emit(GAME_STATE_GAME_OVER)

func _on_restart_game_pressed() -> void:
	game_state_change.emit(GAME_STATE_START)
	game_state_change.emit(GAME_STATE_PLAY)
