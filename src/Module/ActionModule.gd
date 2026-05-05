# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# ActionModule.gd
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
class_name ActionModule

@export var mod_item: ItemModule
@export var default: Array[Action] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; # {action alias: action ref}

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)

func append_actions(__actions: Array[Action], __log: bool = false) -> void:
	if __actions.is_empty(): return
	var __loaded_actions: PackedStringArray
	for i: int in __actions.size():
		var __cur: Action = __actions[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("ActionModule: action on index %s has no alias. Skipping it." % i)
			continue
		if __cur.alias in __loaded_actions:
			printerr("ActionModule: action '%s' has the same alias as a previously loaded action. Please unload that one then append it." % i)
			continue
		if not __cur.check():
			printerr("ActionModule: action '%s' did not pass Action.check()." % __cur.alias)
			continue
		__ref = weakref(__cur)
		loaded.set(__cur.alias, __ref)
		__loaded_actions.append(__cur.alias)
	loaded.sort()
	if __log:
		__loaded_actions.sort()
		print("ActionModule: %s loaded:\n- %s" % [__loaded_actions.size(), \
			"\n- ".join(__loaded_actions)
		])

func remove_actions(__rm_action_aliases: Array[StringName]) -> void:
	if __rm_action_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_action_aliases:
			loaded.erase(__alias)

func run(__action: StringName, __param_dict: Dictionary) -> bool:
	var __ref: WeakRef = loaded.get(__action, null)
	var __act: Action = null
	if __ref == null:
		printerr("ActionModule: action '%s' not found or loaded." % __action)
		return false
	__act = __ref.get_ref()
	if __act == null:
		printerr("ActionModule: failed to get a reference to action '%s'." % __action)
		return false
	var __result: bool = __act.execute(mod_item, __param_dict)
	if not __result:
		printerr("ActionModule: action '%s' failed." % __action)
	return __result
