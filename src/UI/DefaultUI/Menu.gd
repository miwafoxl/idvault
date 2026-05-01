extends Resource
class_name Menu

@export var alias: StringName = &"";
@export var src: GDScript = null
var popup: PopupMenu

func check() -> bool:
	if src == null:
		printerr("Menu: menu '%s' has no source. Skipping it.", alias)
		return false
	var __obj: Object = Object.new()
	__obj.set_script(src)
	if not __obj.has_method(&"build"):
		printerr("Menu: source for menu '%s' has no build() method. Skipping it." % alias)
		return false
	__obj.free()
	return true

func get_menu(__param: Dictionary = {}) -> ContextMenu:
	var __obj: Object = Object.new()
	var __result: ContextMenu = null
	__obj.set_script(src)
	__result = __obj.build(__param)
	__obj.free()
	return __result
