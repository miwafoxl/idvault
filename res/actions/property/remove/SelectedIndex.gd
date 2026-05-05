# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/property/remove/SelectedIndex.gd
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

## Remove properties to selected items by their index
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	# Every item in __args is a property
	var __rm_idx: Array[int] = []
	if __mod_item.selected_items.is_empty():
		push_warning("property.remove.selected_index: Nothing selected")
		return false
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"prop_idx" when __value is Array:
				for __idx: Variant in __value:
					if __idx is int:
						__rm_idx.append(int(__idx))
				if __rm_idx.is_empty(): 
					return false
			_:
				push_warning("property.remove.selected_index:: invalid key '%s'\
				-> prop_idx" % __key)
	#endregion Parameter processing
	var __success: bool = true
	for __item: Item in __mod_item.selected_items:
		if not __item.remove_properties_index(__rm_idx):
			__success = false
	
	return __success
