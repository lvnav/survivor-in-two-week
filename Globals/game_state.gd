extends Node

var game_state: GameStateEnum.State = GameStateEnum.State.START

signal game_state_change

func start_game() -> void:
	game_state = GameStateEnum.State.PLAY
	game_state_change.emit(GameStateEnum.State.PLAY)

func end_game() -> void:
	game_state = GameStateEnum.State.GAME_OVER
	game_state_change.emit(GameStateEnum.State.GAME_OVER)

func restart_game() -> void:
	game_state_change.emit(GameStateEnum.State.START)
	start_game()
