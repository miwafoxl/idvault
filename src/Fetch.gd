# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Fetch.gd
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

extends Resource
class_name Fetch

@export var alias: StringName = &"";
@export var author: String = "";
@export var src: GDScript = null
var checked: bool = false

signal post(result: Variant, id: String)

func check() -> bool:
	if src == null:
		printerr("Fetch: fetch '%s' has no source. Skipping it.", alias)
		return false
	var __obj: Object = Object.new()
	__obj.free.call_deferred()
	__obj.set_script(src)
	if not __obj.has_method(&"run"):
		printerr("Fetch: source for fetch '%s' has no run() method. Skipping it." % alias)
		return false
	checked = true
	return checked

func execute(__mod_item: ItemModule, __param: Dictionary, __post_id: String) -> void:
	if not checked:
		printerr("Fetch: can't run fetch '%s' because it has not been checked by FetchModule." % alias)
		return
	var __obj: Object = Object.new()
	__obj.free.call_deferred()
	__obj.set_script(src)
	post.emit(__obj.run(__mod_item, __param), __post_id)
