# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/stage/Alphabetical.gd
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

func order(a: Item, b: Item) -> bool:
	var a_text: String = a.get_valid_string_display_or_empty()
	var b_text: String = b.get_valid_string_display_or_empty()
	if a_text.is_empty() and b_text.is_empty(): return false # i don't know man
	if a_text.is_empty() and !b_text.is_empty(): return false
	if !a_text.is_empty() and b_text.is_empty(): return true
	
	return a_text.naturalnocasecmp_to(b_text) > 0

## Stage items in alphabetically
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
	#endregion Parameter processing
	if __items.is_empty():
		__items = __mod_item.unordered_items
	__items.sort_custom(order)
	__mod_item.stage_items(__items)
	return true
