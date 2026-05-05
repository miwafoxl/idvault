# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/remove/PropertyID.gd
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

## Removes specific properties from items by property ID
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __items: Array[Item] = []
	var __rm_property_ids: Array[String] = []
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item" when __value is Array:
				for __arg in __value:
					if __arg is Item: __items.append(__arg as Item)
				if __items.is_empty(): 
					return false
			"property_id" when __value is Array:
				for __arg in __value:
					if __arg is String: 
						__rm_property_ids.append(__arg as String)
				if __rm_property_ids.is_empty():
					return false
			_:
				push_warning("item.remove.property_id: invalid key '%s'\
				-> item, property_id" % __key)
	#endregion Parameter processing
	for __item: Item in __items:
		__item.remove_properties(__rm_property_ids)
	return true
