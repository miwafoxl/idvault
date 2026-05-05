# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/select/ByItemIndex.gd
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

## Select items by Item index. If items aren't existent, nothing happens.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool: 
	var __select_indexes: Array[int]
	var __nothing_selected: bool = false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_idx" when __value is Array:
				for __id: int in __value:
					if __id is int:
						__select_indexes.append(__id)
			"only_if_nothing_selected" when __value is bool:
				if __value is bool:
					__nothing_selected = __value
			_:
				push_warning("items.select.by_item_index: invalid key '%s'\
				-> item_idx, only_if_nothing_selected" % __key)
	#endregion Parameter processing
	if __nothing_selected:
		if __mod_item.selected_items.is_empty(): return true
	__mod_item.select_items_at_stage_index(__select_indexes)
	return true
