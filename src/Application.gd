# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Application.gd
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

extends Node
class_name Application

@export var default_ui: PackedScene
var ui: UI = null

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	ui = __node
	ui.modules({
		"item": %ITEM_MODULE })
	ui.trigger.connect(process_trigger)
	%ITEM_MODULE.stage_updated.connect(ui.update, ConnectFlags.CONNECT_DEFERRED)
	%ITEM_MODULE.selection_updated.connect(ui.update_selection, ConnectFlags.CONNECT_DEFERRED)
	add_child(ui, true)

func ui_request(__request: StringName, __param: Dictionary) -> void:
	ui.request(__request, __param)

func process_trigger(__tr: Trigger) -> void:
	if (__tr == null) or (__tr.relevant_id.is_empty()):
		printerr("Received invalid or null trigger")
		return
	match __tr.type:
		Trigger.TriggerTypes.ACTION:
			%ACTION_MODULE.run(__tr.relevant_id, __tr.parameters)
		Trigger.TriggerTypes.UI_REQUEST:
			ui_request(__tr.relevant_id, __tr.parameters)
		_:
			printerr("Invalid trigger type '%s'" % \
				Trigger.TriggerTypes.keys()[__tr.type])

func _ready() -> void:
	%ACTION_MODULE.append_actions(%ACTION_MODULE.default)
	%ACTION_MODULE.trigger.connect(process_trigger)
	%ITEM_MODULE.trigger.connect(process_trigger)
	%TEST_MODULE.append_tests(%TEST_MODULE.tests)
	%TEST_MODULE.do_tests()
	swap_ui(default_ui)
