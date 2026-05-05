# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/deselect/ByItemID.gd
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

## Deselect items. If items aren't selected, nothing happens.
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
				push_warning("items.deselect.by_item_id: invalid key '%s'\
				-> item_id" % __key)
	#endregion Parameter processing
	var __get_id: Array[Item] = __mod_item.get_item_by_id(__item_ids)
	__mod_item.deselect_items(__get_id)
	return true
