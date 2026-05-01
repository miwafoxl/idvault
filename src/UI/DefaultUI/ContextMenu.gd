extends PopupMenu
class_name ContextMenu

signal action_query(action: StringName, param: Dictionary)

func item_pressed(__id: int) -> void:
	var __param: Dictionary = self.get_item_metadata(__id)
	action_query.emit(__param)

func check_visibility() -> void:
	if not visible: queue_free()

func _ready() -> void:
	id_pressed.connect(item_pressed)
	visibility_changed.connect(check_visibility)
