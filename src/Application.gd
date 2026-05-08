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

#region OVERRIDES

func _ready() -> void:
	%ACTION_MODULE.trigger.connect(process_trigger)
	%ITEM_MODULE.trigger.connect(process_trigger)
	%FETCH_MODULE.trigger.connect(process_trigger)
	%ACTION_MODULE.append_actions(%ACTION_MODULE.default)
	%FETCH_MODULE.append_fetch(%FETCH_MODULE.default, true)
	%TEST_MODULE.append_tests(%TEST_MODULE.tests)
	%TEST_MODULE.do_tests()
	swap_ui(default_ui)
	
#endregion OVERRIDES
#region UI CALLS

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	ui = __node
	ui.trigger.connect(process_trigger)
	%ITEM_MODULE.stage_updated.connect(ui.update, ConnectFlags.CONNECT_DEFERRED)
	%ITEM_MODULE.selection_updated.connect(ui.update_selection, ConnectFlags.CONNECT_DEFERRED)
	add_child(ui, true)

func ui_request(__request: StringName, __param: Dictionary) -> void:
	ui.request(__request, __param)

func broadcast_fetch_to_ui(__result: Dictionary) -> void:
	ui.receive_fetch(__result)

#endregion UI CALLS
#region FETCH RETURNS

var awaiting_fetch_tick: int = 0
var awaiting_fetch_ids: Array[String] = []
var process_fetch: bool = false

func _process(__delta: float) -> void:
	if process_fetch:
		var __size: int = awaiting_fetch_ids.size()
		if __size == 0:
			awaiting_fetch_tick = 0
			process_fetch = not process_fetch
			return
		var __cur_id: String = awaiting_fetch_ids[awaiting_fetch_tick]
		if not %FETCH_MODULE.is_finished(__cur_id):
			awaiting_fetch_tick = (awaiting_fetch_tick + 1) % __size
			return
		broadcast_fetch_to_ui({
			__cur_id: %FETCH_MODULE.get_result(__cur_id)
		})

#endregion FETCH RETURNS
#region PROCESS TRIGGER

func process_trigger(__tr: Trigger) -> void:
	if (__tr == null) or (__tr.relevant_id.is_empty()):
		printerr("Received invalid or null trigger")
		return
	match __tr.type:
		Trigger.TriggerTypes.ACTION:
			%ACTION_MODULE.run(__tr.relevant_id, __tr.parameters)
		Trigger.TriggerTypes.FETCH:
			var __tag: String = __tr.parameters.get("_tag", "")
			if __tag.is_empty():
				printerr("Application::process_trigger: Trigger.FETCH needs a _tag.")
				return
			%FETCH_MODULE.run(__tr.relevant_id, __tr.parameters, __tag)
			awaiting_fetch_ids.append(__tag)
			process_fetch = true
		Trigger.TriggerTypes.UI_REQUEST:
			ui_request(__tr.relevant_id, __tr.parameters)
		_:
			printerr("Invalid trigger type '%s'" % \
				Trigger.TriggerTypes.keys()[__tr.type])

#endregion PROCESS TRIGGER
