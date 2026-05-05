# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# ListCollapsibleHead.gd
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

extends DefaultUI_Widget
class_name DefaultUI_ListCollapsibleHead

@export_category("INTERNAL NODES")
@export var BUT_COLLAPSE: Button
@export var BUT_HEAD_OPTIONS: Button
@export var CONTENT_APPEND: VBoxContainer
@export var TXT_HEADER: Label

@export_category("GENERAL")
@export var contents: Control
@export var header_tr_string: StringName
@export var options_menu_id: StringName

var collapsed: bool = false
var related_item_id: String
var order: int = 0

func update_collapse() -> void:
	contents.set_visible(not collapsed)
	if collapsed:
		BUT_COLLAPSE.set_text(tr(&"WIDGET.LIST_HEADER.SHOW"))
	else:
		BUT_COLLAPSE.set_text(tr(&"WIDGET.LIST_HEADER.COLLAPSE"))

func toggle_collapse() -> void:
	collapsed = not collapsed
	update_collapse()

func collect_data() -> Dictionary:
	var __collected: Dictionary
	var __collect_method: StringName = &"collect"
	if contents.has_method(__collect_method):
		__collected = contents.call(__collect_method)
	else:
		printerr(("DefaultUI_ListCollapsibleHead: head '%s' data cannot be " % header_tr_string) + \
		"collected — contents doesn't implement '%s'" % __collect_method)
	return __collected

func _ready() -> void:
	TXT_HEADER.set_text(tr(header_tr_string))
	if options_menu_id.is_empty():
		BUT_HEAD_OPTIONS.hide()
	else:
		BUT_HEAD_OPTIONS.pressed.connect(trigger.emit.bind(
			Trigger.new(
				Trigger.TriggerTypes.UI_REQUEST,
				options_menu_id, {
					"item_id": related_item_id,
					"param_idx": order,
				}
			)
		))
	CONTENT_APPEND.add_child(contents)
	BUT_COLLAPSE.pressed.connect(toggle_collapse)
	
	update_collapse()
