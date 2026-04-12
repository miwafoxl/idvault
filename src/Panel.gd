@abstract
extends Control
class_name UI_Panel

@warning_ignore_start("unused_signal")
signal request_menu(menu_id: StringName, param: Dictionary)
signal trigger(tr: Trigger)
@warning_ignore_restore("unused_signal")

func handle_menu_request(__menu_id: StringName, __param: Dictionary) -> void:
	pass

func update() -> void:
	pass
