extends Resource
class_name Test

@export var name: StringName = &"";
@export var src: GDScript = null
var checked: bool = false

func check() -> bool:
	if src == null:
		printerr("Test: test '%s' has no source. Skipping it.", name)
		return false
	var __obj: Object = Object.new()
	__obj.set_script(src)
	if not __obj.has_method(&"run"):
		printerr("Test: source for test '%s' has no test() method. Skipping it." % name)
		return false
	checked = true
	__obj.free()
	return checked

func execute(__mod_item: ItemModule, __mod_action: ActionModule) -> bool:
	if not checked:
		printerr("Test: can't run test '%s' because it has not been checked by TestModule." % name)
		return false
	var __obj: Object = Object.new()
	var __result: bool = false
	__obj.set_script(src)
	__result = __obj.run(__mod_item, __mod_action)
	__obj.free()
	return __result
