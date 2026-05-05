# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/dialog/SelectedItemProperties.gd
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

## Opens the item properties dialog
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	if __mod_item.selected_items.is_empty(): return true
	__mod_item.trigger.emit(Trigger.new(
		Trigger.TriggerTypes.UI_REQUEST,
		&"dialog:item_properties", {
			"item": __mod_item.selected_items[0]} 
	)) # TODO: Support bulk edit
	return true
