extends Control

signal start_game
@onready var start_button: Button = $StartButton


func _on_start_button_pressed() -> void:
	start_game.emit()

func _on_game_state_change(game_state: String) -> void:
	if game_state == "play":
		start_button.hide()
