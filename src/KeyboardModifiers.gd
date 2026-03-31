extends Node

@export var is_shift_modifier: bool = false
@export var is_alt_modifier: bool = false

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	print_debug(event as InputEventKey)
	if (event as InputEventKey).keycode == 4194325 and event.is_pressed():
		is_shift_modifier = true
	if (event as InputEventKey).keycode == 4194325 and not event.is_pressed():
		is_shift_modifier = false
	if (event as InputEventKey).keycode == 4194328 and event.is_pressed():
		is_alt_modifier = true
	if (event as InputEventKey).keycode == 4194328 and not event.is_pressed():
		is_alt_modifier = false
