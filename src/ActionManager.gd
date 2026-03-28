extends Node
class_name ActionManager

@export var manager: Manager
@export var default: Array[Action] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; # {action alias: action ref}


func append_actions(__actions: Array[Action]) -> void:
	if __actions.is_empty(): return
	for i: int in __actions.size():
		var __cur: Action = __actions[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("ActionManager: action on index %s has no alias. Skipping it." % i)
		if not __cur.check():
			printerr("ActionManager: action '%s' did not pass Action.check()." % __cur.alias)
		__ref = weakref(__cur)
		loaded.set(__cur.alias, __ref)
	loaded.sort()

func remove_actions(__rm_action_aliases: Array[StringName]) -> void:
	if __rm_action_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_action_aliases:
			loaded.erase(__alias)

func run(__action: StringName, ...args: Array) -> bool:
	var __ref: WeakRef = loaded.get(__action, null)
	var __act: Action = null
	if __ref == null:
		printerr("ActionManager: action '%s' not found or loaded." % __action)
		return false
	__act = __ref.get_ref()
	if __act == null:
		printerr("ActionManager: failed to get a reference to action '%s'." % __action)
		return false
	var __result: bool = __act.execute(manager, args)
	if not __result:
		push_warning("ActionManager: action '%s' failed." % __action)
	return __result
