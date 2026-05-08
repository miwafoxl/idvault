# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/fetches/StagedItemsPage.gd
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

## Returns RefCounted reference of items in stage by offset page_size * page_index
func run(__mod_item: ItemModule, __param: Dictionary) -> Dictionary:
	var __page_size: int = 1
	var __requested_index: int = 0
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"page_size" when __value is int:
				__page_size = __value
			"page_index" when __value is int:
				__requested_index = __value
			_ when not __key.begins_with("_"):
				push_warning("staged_items_page: invalid key '%s'\
				-> page_size, page_index" % __key)
	#endregion Parameter processing
	var __dict: Dictionary = {}
	__dict.set("items", __mod_item.get_staged_items_pages(__page_size, __requested_index))
	__dict.set("page_count", __mod_item.get_staged_items_total_pages(__page_size))
	return __dict
