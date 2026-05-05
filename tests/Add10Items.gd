# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Add10Items.gd
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

extends Object
var procedures: Array[Callable] = []

## Adds 10 items and removes all 10 afterwards
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = [
		__mod_action.run.bindv([&"items.append.testitem", {"count": 10}]),
		func() -> bool: return __mod_item.unordered_items.size() == 10,
		__mod_action.run.bindv([&"items.stage.unordered", {}]),
		__mod_action.run.bindv([&"items.select.by_item_index", {"item_idx": range(10)}]),
		func() -> bool: return __mod_item.selected_items.size() == 10,
		__mod_action.run.bindv([&"items.remove.selected", {}]),
		func() -> bool: return __mod_item.unordered_items.size() == 0,
		func() -> bool: return __mod_item.selected_items.size() == 0,
		func() -> bool: return __mod_item.staged_items.size() == 0,
	]
	#endregion PROCEDURES
	#region CALL PROCEDURES
	for i in procedures.size():
		var __call: Callable = procedures[i]
		if __call.call() == false:
			return i
	#endregion CALL PROCEDURES
	return -1
