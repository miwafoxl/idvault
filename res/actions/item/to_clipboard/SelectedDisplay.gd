# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# res/actions/item/to_clipboard/SelectedDisplay.gd
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

## Retrieves valid string from selected items and set them to clipboard,
## separated into spaces.
func run(__mod_item: ItemModule, __param: Dictionary) -> bool:
	var __display: PackedStringArray = []
	for __item: Item in __mod_item.selected_items:
		var __string: String = __item.get_valid_string_display_or_empty()
		if not __string.is_empty():
			__display.append(__string)
	if __display.is_empty():
		return false # TODO: Add global setting to limit the clipboard length
	DisplayServer.clipboard_set(" ".join(__display)) # TODO: Global setting to change " " here
	return true
