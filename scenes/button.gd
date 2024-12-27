extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("allez")
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	print("mouse-entered")
	pass # Replace with function body.


func _on_button_down() -> void:
	print("button-downe")
	pass # Replace with function body.


func _on_button_up() -> void:
	print("up")
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	print(event)
	pass # Replace with function body.
