extends Node

@export var is_shift_modifier: bool = false
@export var is_alt_modifier: bool = false

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	print_debug(event as InputEventKey)
	is_shift_modifier = event.is_action_pressed("shift_mod")
	is_alt_modifier = event.is_action_pressed("alt_mod")
