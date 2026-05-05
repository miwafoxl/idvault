# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/property/append/ToItemID.gd
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

## Appends properties to many item IDs
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __item_id: Array[String]
	var __properties: Array[Property]
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is Array:
				for __id: Variant in __value:
					if __id is String:
						__item_id.append(__id as String)
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__properties.append(__property as Property)
			_:
				push_warning("property.append.to_item_id: invalid key '%s'\
				-> item_id properties" % __key)
	#endregion Parameter processing
	var __items_updated: Array[Item] = []
	for __id: String in __item_id:
		var __item_cx: Array = __mod_item.get_from_cache("by_item_id", __id)
		if __item_cx.is_empty():
			push_warning("property.append.to_item_id: Failed to " + \
			"get cache for item id '%s' (item might have been deleted)." % [__item_id])
			continue
		var __item: Item = (__item_cx[0] as WeakRef).get_ref()
		if __item == null:
			push_warning("property.append.to_item_id: Failed to " + \
			"get reference to item id '%s' (item might have been deleted)." % [__item_id])
			continue
		__item.append_properties(__properties)
		__items_updated.append(__item)
		
	if __items_updated: # TODO: reload_cache only affected items
		__mod_item.reload_cache(__mod_item.unordered_items)
		__mod_item.stage_updated.emit()
		__mod_item.trigger.emit(Trigger.new(  # TODO: Temporary. Actions shoudn't trigger UI
			Trigger.TriggerTypes.UI_REQUEST, # requests directly, but not calling this trigger
			&"dialog:item_properties"))      # here won't update the item_preperties window.
	return false
