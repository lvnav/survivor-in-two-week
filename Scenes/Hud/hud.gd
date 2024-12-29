class_name Hud extends Control

@onready var player: Player = $"../Player"
@onready var remaining_life: Label = $LifeIndicator/RemainingLife
@onready var total_life: Label = $LifeIndicator/TotalLife
@onready var score_indicator: Label = $ScoreIndicator
@onready var level_up_menu: Control = $LevelUpMenu
@onready var level_up_card: Control = $LevelUpCard
@onready var level: Level = $".."

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	remaining_life.text = str(player.remaining_life)
	total_life.text = str(player.total_life)
	score_indicator.text = str(level.score_value)
	pass

func _on_level_up(up_choices: Array) -> void:
	for up_choice: Dictionary in up_choices:
		var button: Button = Button.new()
		button.text = up_choice["type"]
		button.process_mode = Node.PROCESS_MODE_ALWAYS
		button.pressed.connect(level._up_button_pressed.bind(up_choice))
		level_up_menu.add_child(button)

func clear_up_interface() -> void:
	for level_up_menu_item: Button in level_up_menu.get_children():
		level_up_menu.remove_child(level_up_menu_item)
	
