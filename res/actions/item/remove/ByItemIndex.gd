# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/remove/ByItemIndex.gd
# ---------------------------------------------------------------
# Copyright (C) 2026   Amanda Severo   Contact: miwafoxl@proton.me
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see https://www.gnu.org/licenses/.

extends Object

## Removes items by index
func run(__mod_item: ItemModule, __param: Dictionary) -> bool: 
	var __indexes: Array[int]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__indexes.append(__id)
			_:
				push_warning("items.remove.by_item_index: invalid key '%s'\
				-> item_idx" % __key)
	#endregion Parameter processing
	return __mod_item.remove_items_stage_index(__indexes)
