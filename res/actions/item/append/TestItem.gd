# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/append/TestItem.gd
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

## Creates and appends an empty item
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __count: int = 1
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"count" when __value is int:
				__count = max(1, __value % 1000)
			_:
				push_warning("item.append.items: invalid key '%s'\
				-> count" % __key)
	#endregion Parameter processing
	var __random_props: Array[Property] = [
		Display.new(RandomString.new("", 12).value, "first test here".repeat(randi() % 3)),
	]
	var __descriptors: Dictionary = __mod_item.item_cache.get("by_descriptor", {})
	var __descriptors_id: Array = __descriptors.keys()
	var __items: Array[Item]
	for i in __count:
		var __props: Array[Property] = [__random_props.pick_random()]
		if __mod_item.unordered_items.size() > 0:
			if not __descriptors_id.is_empty(): 
				__props.append(Link.new(
					__mod_item.unordered_items.pick_random().id, # FROM ID
					__descriptors_id.pick_random(), # TO ID
			))
		
		if __mod_item.unordered_items.size() == 0:
			__props.append(Descriptor.new(["abc", "def", "ghj"].pick_random()))
		__items.append(Item.new("", __props))
	return __mod_item.append_items(__items)
