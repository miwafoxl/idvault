# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# MenuModule.gd
# ---------------------------------------------------------------
# Copyright (C) 2026   Amanda Severo   Contact: miwafoxl@proton.me
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see https://www.gnu.org/licenses/.

extends Module
class_name DefaultUI_MenuModule

@export var default: Array[Menu] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; #  {alias: menu ref}
@export var theme: Theme

signal trigger(tr: Trigger)

func append_menus(__menus: Array[Menu], __log: bool = false) -> void:
	if __menus.is_empty(): return
	var __loaded_menus: PackedStringArray
	for i: int in __menus.size():
		var __cur: Menu = __menus[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("DefaultUI_MenuModule: menu id on index %s has no alias. Skipping it." % i)
			continue
		if __cur.alias in __loaded_menus:
			printerr("DefaultUI_MenuModule: menu id '%s' has the same alias as a previously loaded menu. Please unload that one then append it." % i)
			continue
		__ref = weakref(__cur)
		loaded.set(__cur.alias, __ref)
		__loaded_menus.append(__cur.alias)
	loaded.sort()
	if __log:
		__loaded_menus.sort()
		print("DefaultUI_MenuModule: %s loaded:\n- %s" % [__loaded_menus.size(), \
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
		printerr("DefaultUI_MenuModule: menu id '%s' not found or loaded." % __menu_id)
		return null
	__menu = __ref.get_ref()
	if __menu == null:
		printerr("DefaultUI_MenuModule: failed to get a reference to menu id '%s'." % __menu_id)
		return null
	var __result: ContextMenu = __menu.get_menu(__param_dict)
	__result.set_theme(theme)
	if __result == null:
		push_warning("DefaultUI_MenuModule: menu id '%s' failed." % __menu_id)
	return __result

func menu_action_callback(__param: Dictionary) -> void:
	if __param.is_empty(): return
	var __action: StringName = __param.keys()[0]
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		__action, __param.values()[0]
	))
