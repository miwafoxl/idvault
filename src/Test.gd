# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Test.gd
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

func execute(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	if not checked:
		printerr("Test: can't run test '%s' because it has not been checked by TestModule." % name)
		return false
	var __obj: Object = Object.new()
	var __result: int = -1
	__obj.set_script(src)
	__result = __obj.run(__mod_item, __mod_action)
	__obj.free()
	return __result
