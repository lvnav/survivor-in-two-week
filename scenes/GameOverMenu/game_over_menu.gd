extends Control

signal restart_game_pressed

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	pass

func _on_game_state_change(game_state: String) -> void:
	if game_state == "game_over":
		show()
	else:
		hide()


func _on_restart_button_pressed() -> void:
	restart_game_pressed.emit()
