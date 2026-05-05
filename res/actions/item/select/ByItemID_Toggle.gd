# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/select/ByItemID_Toggle.gd
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

## Toggle selection for items by Item ID. If items aren't existent, nothing happens.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool: 
	var __item_ids: Array[String]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: Variant in __value:
					if __id is String:
						__item_ids.append(__id)
			_:
				push_warning("items.select.by_item_id: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __cached: Array = __mod_item.get_from_cache_many("by_item_id", __item_ids)
	var __deselect: Array[Item]
	var __select: Array[Item]
	for __item_cx: Array in __cached:
		var __item: Item = (__item_cx[0] as WeakRef).get_ref()
		if __item == null: continue
		__deselect.append(__item)
	for i: int in __deselect.size():
		var __item: Item = __deselect[i]
		if __item not in __mod_item.selected_items:
			__select.append(__item)
			__deselect.set(i, null)
	__mod_item.select_items(__select, true)
	__mod_item.deselect_items(__deselect)
	return true
