class_name EnvironmentalState extends Node

@onready var container: VBoxContainer = $Container
@onready var actual_state_timer: Timer = $ActualStateTimer

var elemental_states: Dictionary = {
	"burning": false, 
	"wet": false
}

var elemental_states_label: Dictionary = {} # follow elemental_state shape with labels instead of bool
var parent: Node2D

@export var priority: int # more priority near zero

signal elemental_states_change(key: String, new_value: bool)
signal elemental_state_consumed

func _ready() -> void:
	if get_parent() == null:
		assert(false, "EnvironmentalState must have a parent")
		
	parent = get_parent()

func _process(delta: float) -> void:
	container.position = get_parent().position
	container.position.x = container.position.x - 100
	
func set_elemental_state(key: String, new_value: bool):
	if !elemental_states.has(key):
		assert(false, "Unexpected key " + key)
	elemental_states[key] = new_value
	elemental_states_change.emit(key, new_value)
	actual_state_timer.start()
	

func is_altered():
	for state in elemental_states.values():
		if state != false:
			return state

func _on_elemental_states_change(key: String, new_value: bool) -> void:
	var label: Label
	if elemental_states_label.has(key):
		label = elemental_states_label[key]
	else:
		label = Label.new()
		elemental_states_label[key] = label
		container.add_child(label)
	
	label.text = str(key, ":", new_value)

func _on_actual_state_timer_timeout() -> void:
	elemental_state_consumed.emit()
		
