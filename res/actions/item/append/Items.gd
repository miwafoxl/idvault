# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/append/Items.gd
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

## Creates and appends a specified amount of empty items
func run(__mod_item: ItemModule, __param: Dictionary) -> bool: 
	var __range: int = 1
	var __init_props: Array[Property] = []
	var __open_item_properties: bool = false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"count" when __value is int:
				__range = max(1, __value % 1000)
			"open_properties" when __value is bool:
				__open_item_properties = __value
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__init_props.append(__property as Property)
			_:
				push_warning("item.append.items: invalid key '%s'\
				-> count, properties, open_properties" % __key)
	#endregion Parameter processing
	var __ids: Array = range(__range)
	var __items: Array[Item] = []	
	for i: int in __ids:
		__items.append(Item.new("", __init_props.duplicate(true)))
	__mod_item.append_items(__items)
	if __open_item_properties:
		__mod_item.select_items(__items)
		__mod_item.trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.dialog.selected_item_properties"
		))
	return true
