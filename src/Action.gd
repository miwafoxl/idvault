extends Resource
class_name Action

@export var alias: StringName = &"";
@export var author: String = "";
@export var src: GDScript = null
var checked: bool = false

func check() -> bool:
	if src == null:
		printerr("Action: action '%s' has no source. Skipping it.", alias)
		return false
	var __obj: Object = Object.new()
	__obj.set_script(src)
	if not __obj.has_method(&"run"):
		printerr("Action: source for action '%s' has no run() method. Skipping it." % alias)
		return false
	checked = true
	__obj.free()
	return checked

func execute(__mod_item: ItemModule, __param: Dictionary) -> bool:
	if not checked:
		printerr("Action: can't run action '%s' because it has not been checked by ActionModule." % alias)
		return false
	var __obj: Object = Object.new()
	var __result: bool = false
	__obj.set_script(src)
	__result = __obj.run(__mod_item, __param)
	__obj.free()
	return __result
