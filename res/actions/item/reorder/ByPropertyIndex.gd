# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/reorder/ByPropertyIndex.gd
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

## Reorder property by moving properties to the desired space.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __item_id: String
	var __param_idx: Array[int]
	var __new_idx: int = 0
	#region Parameter processing
	for __key: String in __param:
		var __value: Variant = __param[__key]
		match __key:
			"item_id" when __value is String:
				__item_id = __value
			"param_idx" when __value is Array:
				for __idx in __value:
					if __idx is int:
						__param_idx.append(__idx)
			"new_idx" when __value is int:
				__new_idx = __value
			_:
				push_warning("items.select.by_item_id: invalid key '%s'\
				-> item_id, param_idx, new_idx" % __key)
	#endregion Parameter processing
	var __get_id: Array[Item] = __mod_item.get_item_by_id([__item_id])
	if __param_idx.is_empty() or __get_id.is_empty() or \
		__get_id[0].has_parameters(): return false
	__get_id[0].reorder_properties(__param_idx, __new_idx)
	__mod_item.trigger.emit(Trigger.new(  # TODO: Temporary. Actions shoudn't trigger UI
		Trigger.TriggerTypes.UI_REQUEST, # requests directly, but not calling this trigger
		&"dialog:item_properties"))      # here won't update the item_preperties window.
	return true
