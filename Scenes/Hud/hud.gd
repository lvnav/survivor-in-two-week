class_name Hud extends CanvasLayer

@onready var player: Player = $"../ProcGenWorld2/Player"
@onready var score_indicator: Label = %ScoreIndicator
@onready var life_indicator: Control = %LifeIndicator
@onready var level_up_menu: Control = $LevelUpMenu
@onready var level_up_card: Control = $LevelUpCard
@onready var level: Level = $".."
@onready var remaining_life: Label = $VBoxContainer/LifeIndicator/RemainingLife
@onready var total_life: Label = $VBoxContainer/LifeIndicator/TotalLife

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	remaining_life.text = str(player.remaining_life)
	total_life.text = str(player.total_life)
	score_indicator.text = str(level.score_value)
	
	var minimum_size: Vector2 = get_viewport().get_camera_2d().get_viewport_rect().size
	level_up_menu.custom_minimum_size = minimum_size / 1.2
	level_up_menu.set_offset(SIDE_LEFT, float(minimum_size.x / 12))
	level_up_menu.set_offset(SIDE_TOP,float(minimum_size.y / 24))
	

func _on_level_up(up_choices: Array) -> void:
	for up_choice: Dictionary in up_choices:
		var button: Button = Button.new()
		button.text = up_choice["description"]
		button.process_mode = Node.PROCESS_MODE_ALWAYS
		button.pressed.connect(level._up_button_pressed.bind(up_choice))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		level_up_menu.add_child(button)

func clear_up_interface() -> void:
	for level_up_menu_item: Button in level_up_menu.get_children():
		level_up_menu.remove_child(level_up_menu_item)
	
