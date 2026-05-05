# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# ItemPropertiesDialog.gd
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
class_name DefaultUI_ItemPropertiesDialog

#region OVERRIDES

func enter_request() -> void:
	var __focus: Control = self.gui_get_focus_owner()
	if not __focus == %BUT_APPLY or __focus == null: return
	var __new_property: Dictionary = %EDITABLELIST.collect_item_node_data()
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"property.edit.apply", __new_property
	))
	handle_close_request.emit(alias)

func close_request(__confirm: bool = false) -> void:
	var __new_property: Dictionary = %EDITABLELIST.collect_item_node_data()
	if not __new_property.is_empty() and not __confirm:
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.UI_REQUEST,
			&"dialog:user_confirmation", 
			{
				"callback": close_request.bind(true),
				"message": tr(&"DIALOG.USER_CONFIRMATION.EXIT_ITEM_PROPERTIES_UNCOMMITED_CHANGES")}
			))
	if __new_property.is_empty() or __confirm: 
		handle_close_request.emit(alias)

#endregion
#region INPUT

func _update_arguments() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	self.set_title(tr(&"DIALOG.ITEM_PROPERTIES.TITLE") + ": %s" % __item.id)
	%EDITABLELIST.contents = [DefaultUI_ItemHolder.new(__item)]
	%EDITABLELIST.reload_contents()
	if not %EDITABLELIST.trigger.is_connected(trigger.emit):
		%EDITABLELIST.trigger.connect(trigger.emit)

func _on_button_apply_button_down() -> void:
	enter_request()

func _on_but_property_add_pressed() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.UI_REQUEST,
		&"menu:property.add_property",
		{
			"callback": %EDITABLELIST.display_item_node,
			"item_id": __item.id,
		}
	))

#endregion INPUT
