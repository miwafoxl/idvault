# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# FetchModule.gd
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
class_name FetchModule

@export var mod_item: ItemModule
@export var default: Array[Fetch] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; # {action alias: action ref}
@export var results: Dictionary[String, Variant]

signal trigger(tr: Trigger)

func append_fetch(__fetch: Array[Fetch], __log: bool = false) -> void:
	if __fetch.is_empty(): return
	var __loaded_fetch: PackedStringArray
	for i: int in __fetch.size():
		var __cur: Fetch = __fetch[i]
		var __ref: WeakRef = null
		if __cur.alias.is_empty():
			printerr("FetchModule::append_fetch: fetch on index %s has no alias. Skipping it." % i)
			continue
		if __cur.alias in __loaded_fetch:
			printerr(("FetchModule::append_fetch: fetch '%s' has the same alias as a " % i) + \
			"previously loaded fetch. Please unload that one then append it.")
			continue
		if not __cur.check():
			printerr("FetchModule::append_fetch: fetch '%s' did not pass Fetch.check()." % __cur.alias)
			continue
		__ref = weakref(__cur)
		if loaded.set(__cur.alias, __ref):
			__loaded_fetch.append(__cur.alias)
	loaded.sort()
	if __log:
		__loaded_fetch.sort()
		print("FetchModule::append_fetch: %s loaded:\n- %s" % [__loaded_fetch.size(), \
			"\n- ".join(__loaded_fetch)
		])

func remove_actions(__rm_action_aliases: Array[StringName]) -> void:
	if __rm_action_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_action_aliases:
			loaded.erase(__alias)

func is_finished(__fetch_id: String) -> bool:
	return results.has(__fetch_id)

func get_result(__fetch_id: String, __erase: bool = true) -> Variant:
	var __result: Variant = results.get(__fetch_id)
	if __erase: 
		results.erase(__fetch_id)
	return __result

func post_result(__result: Variant, __id: String) -> void:
	results.set(__id, __result)

func run(__fetch: StringName, __param_dict: Dictionary, __tag: String) -> String:
	var __ref: WeakRef = loaded.get(__fetch, null)
	var __fetch_id: String = __tag
	var __get: Fetch = null
	if __ref == null:
		printerr(("FetchModule::run: fetch '%s' (tag '%s') " % [__fetch, __tag]) + \
		"not found or loaded.")
		return ""
	__get = __ref.get_ref()
	if __get == null:
		printerr("FetchModule::run: fetch to get a reference to fetch " + \
		"'%s' (tag '%s')." % [__fetch, __tag])
		return ""
	__get.post.connect(post_result, ConnectFlags.CONNECT_ONE_SHOT)
	__get.execute.call_deferred(mod_item, __param_dict, __tag)
	return __fetch_id
