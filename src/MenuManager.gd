extends Node
class_name MenuManager

@export var default: Array[Menu] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; #  {alias: menu ref}
@export var theme: Theme


func append_menus(__menus: Array[Menu], __log: bool = false) -> void:
	if __menus.is_empty(): return
	var __loaded_menus: PackedStringArray
	for i: int in __menus.size():
		var __cur: Menu = __menus[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("MenuManager: menu id on index %s has no alias. Skipping it." % i)
			continue
		if __cur.alias in __loaded_menus:
			printerr("MenuManager: menu id '%s' has the same alias as a previously loaded menu. Please unload that one then append it." % i)
			continue
		__ref = weakref(__cur)
		loaded.set(__cur.alias, __ref)
		__loaded_menus.append(__cur.alias)
	loaded.sort()
	if __log:
		__loaded_menus.sort()
		print("MenuManager: %s loaded:\n- %s" % [__loaded_menus.size(), \
			"\n- ".join(__loaded_menus)
		])

func remove_menu(__rm_menu_aliases: Array[StringName]) -> void:
	if __rm_menu_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_menu_aliases:
			loaded.erase(__alias)

func retrieve_menu(__menu_id: StringName, __param_dict: Dictionary = {}) -> ContextMenu:
	# TODO: Support menu parameters
	var __ref: WeakRef = loaded.get(__menu_id, null)
	var __menu: Menu = null
	if __ref == null:
		printerr("MenuManager: menu id '%s' not found or loaded." % __menu_id)
		return null
	__menu = __ref.get_ref()
	if __menu == null:
		printerr("MenuManager: failed to get a reference to menu id '%s'." % __menu_id)
		return null
	var __result: ContextMenu = __menu.get_menu(__param_dict)
	__result.set_theme(theme)
	if __result == null:
		push_warning("MenuManager: menu id '%s' failed." % __menu_id)
	return __result

func menu_action_callback(__param: Dictionary) -> void:
	if __param.is_empty(): return
	var __action: StringName = __param.keys()[0]
	print_debug(__param)
