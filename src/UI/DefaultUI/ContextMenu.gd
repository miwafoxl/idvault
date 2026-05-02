extends PopupMenu
class_name ContextMenu

signal action_query(action: StringName, param: Dictionary)

func item_pressed(__id: int) -> void:
	# Item pressed on menu items can either call local callbacks or action triggers.
	# At the moment, there's no need for multiplicty (e.g. calling 2 actions at once), that's
	# why there's a [0] in values typed as arrays.
	var __param: Dictionary = self.get_item_metadata(__id)
	var __key: Variant = __param.keys()[0] 
	# Checks if it's either a StringName (an action ID) or a Callable
	if __key is StringName:
		action_query.emit(__param)
	elif __key is Callable: 
		var __func: Callable = __key
		if not __func.is_valid():
			printerr("ContextMenu::item_pressed: callable provided '%s' is not valid" % __func.get_method())
			return
		__func.callv(__param.values()[0])
	else:
		push_warning("ContextMenu::item_pressed: invalid key type returned by item_pressed get_item_metadata")

func check_visibility() -> void:
	if not visible: queue_free()

func _ready() -> void:
	id_pressed.connect(item_pressed)
	visibility_changed.connect(check_visibility)
