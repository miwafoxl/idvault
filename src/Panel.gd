@abstract
extends Control
class_name UI_Panel

@warning_ignore("unused_signal")
signal request_menu(menu_id: StringName, param: Dictionary)

func handle_menu_request(__menu_id: StringName, __param: Dictionary) -> void:
	pass

func update() -> void:
	pass
