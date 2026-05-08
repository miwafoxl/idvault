# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Trigger.gd
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

extends Resource
class_name Trigger

@export var type: TriggerTypes = TriggerTypes.TRIGGER
@export var relevant_id: StringName = ""
@export var parameters: Dictionary = {}

func _init(__type: TriggerTypes, __relevant_id: StringName = &"", \
		__param: Dictionary = {}) -> void:
	self.type = __type
	self.relevant_id = __relevant_id
	self.parameters = __param

enum TriggerTypes {
	TRIGGER,
	NONE,
	ACTION,
	FETCH,
	UI_REQUEST,
}
