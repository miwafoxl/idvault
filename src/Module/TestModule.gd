extends Module
class_name TestModule

@export var enabled: bool = true
@export var mod_item: ItemModule
@export var mod_action: ActionModule
@export var tests: Array[Test] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; # {test alias: test ref}

func append_tests(__tests: Array[Test], __log: bool = false) -> void:
	if __tests.is_empty(): return
	var __loaded_tests: PackedStringArray
	for i: int in __tests.size():
		var __cur: Test = __tests[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("TestModule: test on index %s has no name. Skipping it." % i)
			continue
		if __cur.alias in __loaded_tests:
			printerr("TestModule: test '%s' has the same name as a previously " + \
			"loaded test. Please unload that one then append it." % i)
			continue
		if not __cur.check():
			printerr("TestModule: test '%s' did not pass Test.check()." % __cur.alias)
			continue
		__ref = weakref(__cur)
		loaded.set(__cur.alias, __ref)
		__loaded_tests.append(__cur.alias)
	loaded.sort()
	if __log:
		__loaded_tests.sort()
		print("ActionModule: %s loaded:\n- %s" % [__loaded_tests.size(), \
			"\n- ".join(__loaded_tests)
		])

func remove_tests(__rm_tests_aliases: Array[StringName]) -> void:
	if __rm_tests_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_tests_aliases:
			loaded.erase(__alias)

func do_tests(__tests: Array[StringName]) -> Array[StringName]:
	var __failed: Array[StringName] = []
	if __tests.is_empty(): return __failed
	for __name: StringName in __tests:
		if run(__name): continue
		__failed.append(__name)
	return __failed

func run(__test_name: StringName) -> bool:
	var __ref: WeakRef = loaded.get(__test_name, null)
	var __test: Test = null
	if __ref == null:
		printerr("TestModule: test '%s' not found or loaded." % __test_name)
		return false
	__test = __ref.get_ref()
	if __test == null:
		printerr("TestModule: failed to get a reference to test '%s'." % __test_name)
		return false
	
	var __process_trigger: Callable = func(__tr: Trigger, __act: ActionModule) -> void:
		if (__tr == null) or (__tr.relevant_id.is_empty()):
			printerr("TestModule::__process_trigger: Received invalid or null trigger")
			return
		match __tr.type:
			Trigger.TriggerTypes.ACTION:
				__act.run(__tr.relevant_id, __tr.parameters)
			_:
				printerr("TestModule::__process_trigger: Invalid trigger type '%s'" % \
					Trigger.TriggerTypes.keys()[__tr.type])
	
	var __mod_item: ItemModule = mod_item.duplicate()
	var __mod_action: ActionModule = mod_action.duplicate()
	__mod_item.trigger.connect(__process_trigger.bind(__mod_action))
	__mod_action.trigger.connect(__process_trigger.bind(__mod_action))
	var __result: bool = __test.execute(mod_item, mod_action)
	__mod_item.queue_free()
	__mod_action.queue_free()
	return __result
