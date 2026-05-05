# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/property/append/Selected.gd
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

## Append properties to selected items
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	# Every item in __args is a property
	var __properties: Array[Property] = []
	if __mod_item.selected_items.is_empty():
		push_warning("property.append.selected: Nothing selected")
		return false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"properties" when __value is Array:
				for __property: Variant in __value:
					if __property is Property:
						__properties.append(__property as Property)
				if __properties.is_empty(): 
					return false
			_:
				push_warning("property.append.selected: invalid key '%s'\
				-> properties" % __key)
	#endregion Parameter processing
	var __success: bool = true
	for __item: Item in __mod_item.selected_items: # TODO: Make this less destructive in case it fails
		var __props: Array[Property] = __properties.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
		for __prop: Property in __props: __prop.flush_id()
		if not __item.append_properties(__props):
			__success = false
	
	if __success: # TODO: reload_cache only affected items
		__mod_item.reload_cache(__mod_item.unordered_items)
		__mod_item.stage_updated.emit()
		__mod_item.trigger.emit(Trigger.new(  # TODO: Temporary. Actions shoudn't trigger UI
			Trigger.TriggerTypes.UI_REQUEST, # requests directly, but not calling this trigger
			&"dialog:item_properties"))      # here won't update the item_preperties window.
	return __success
