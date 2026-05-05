# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Link.gd
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

extends Property
class_name Link

@export var from_id: String;
@export var to_id: String;
@export var parameters: Dictionary[String, Variant] = {};
@export var user_created: bool = false

func append_parameter(__parameters: Dictionary[String, Variant]) -> bool:
	if not __parameters.is_empty():
		parameters.merge(__parameters)
		return true
	return false

func remove_parameter(__rm_parameter_id: Array[String]) -> bool:
	if not __rm_parameter_id.is_empty():
		for __param_id: String in parameters.keys():
			if __param_id not in __rm_parameter_id: continue
			return parameters.erase(__param_id)
	return true

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.LINK"

func _init(__link_to_id: String = "", __link_from_id: String = "",
		__parameters: Dictionary[String, Variant] = {},
		__user_created: bool = false) -> void:
	self.from_id = __link_from_id
	self.to_id = __link_to_id
	self.user_created = __user_created
	append_parameter(__parameters)
	super.flush_id()
