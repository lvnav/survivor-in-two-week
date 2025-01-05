extends Control

@onready var start_button: Button = $StartButton

func _ready() -> void:
	GameState.game_state_change.connect(_on_game_state_change)

func _on_start_button_pressed() -> void:
	GameState.start_game()

func _on_game_state_change(game_state: GameStateEnum.State) -> void:
	if game_state == GameStateEnum.State.PLAY:
		hide()
