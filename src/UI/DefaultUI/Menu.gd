# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Menu.gd
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
