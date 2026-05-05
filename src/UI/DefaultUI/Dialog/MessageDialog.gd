# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# MessageDialog.gd
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

extends DefaultUI_Dialog
class_name DefaultUI_MessageDialog

const MIN_LABEL_SIZE: int = 70

@export var message_node: RichTextLabel
@export var confirm_node: Button

#region OVERRIDES

func enter_request() -> void:
	close_request()

#endregion OVERRIDES
#region INPUT

func _on_about_to_popup() -> void:
	message_node.text = args.get("message")
	var __size_y: int = ceil(message_node.get_size().y)
	if __size_y > MIN_LABEL_SIZE:
		var __new_y: int = __size_y - MIN_LABEL_SIZE
		self.set_size(Vector2i(self.size.x, self.size.y + __new_y))

func _on_button_ok_button_up() -> void:
	close_request()

#endregion INPUT
