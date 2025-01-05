extends Control

func _ready() -> void:
	GameState.game_state_change.connect(_on_game_state_change)
	hide()

func _process(_delta: float) -> void:
	pass

func _on_game_state_change(game_state: GameStateEnum.State) -> void:
	if game_state == GameStateEnum.State.GAME_OVER:
		show()
	else:
		hide()

func _on_restart_button_pressed() -> void:
	GameState.restart_game()
