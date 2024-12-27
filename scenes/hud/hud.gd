extends Control

@onready var player: CharacterBody2D = $"../Player"
@onready var remaining_life: Label = $LifeIndicator/RemainingLife
@onready var total_life: Label = $LifeIndicator/TotalLife
@onready var score_indicator: Label = $ScoreIndicator
@onready var level_up_menu: Control = $LevelUpMenu
@onready var level_up_card: Control = $LevelUpCard
@onready var level: Sprite2D = $".."

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	remaining_life.text = str(player.remaining_life)
	total_life.text = str(player.total_life)
	
	pass

func _on_level_up(up_choices: Array) -> void:
	for up_choice in up_choices:
		var button = Button.new()
		button.text = up_choice["type"]
		#button.pressed.connect(level._up_button_pressed.bind(up_choice))
		level_up_menu.add_child(button)


func _on_gui_input(event: InputEvent) -> void:
	print(event)
	pass # Replace with function body.
