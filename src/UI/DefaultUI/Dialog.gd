# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Dialog.gd
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

@abstract
extends Window
class_name DefaultUI_Dialog

@export var args: Dictionary = {}
@export var important: bool = false
var alias: StringName

@warning_ignore_start("unused_signal")
signal trigger(tr: Trigger)
signal handle_close_request(StringName)
@warning_ignore_restore("unused_signal")
#region OVERRIDES

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			close_request()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	if event.is_action_pressed("enter"):
		enter_request()
	if event.is_action_pressed("exit"):
		close_request()
			
func _ready() -> void:
	self.visible = false
	self.set_force_native(true)

func _update_arguments() -> void:
	pass

func close_request() -> void:
	handle_close_request.emit(alias)

#endregion OVERRIDES
#region ABSTRACT FUNCTIONS

@abstract
func enter_request() -> void

#endregion

func pop() -> void:
	self.visible = true
	self.set_exclusive(important)
	self.popup_centered()
