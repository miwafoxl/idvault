# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Property.gd
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
extends Resource
class_name Property

@export var id: String = ""
@export var default: StringName = &"default"
@export var category: StringName = &"general";

func deserialized(__include_prop_id: bool = true) -> Dictionary:
	var __property_dict: Dictionary = {}
	for __dict: Dictionary in self.get_property_list():
		var __usage: int = __dict.get("usage", 0)
		if not __usage == 0x1006: continue
		var __p_name: String = __dict.get("name", "")
		var __p_value: Variant = self.get(__p_name)
		if (not __include_prop_id) and (__p_name == "id"): continue
		__property_dict.set(__p_name, __p_value)
	return __property_dict

func serialize(__dict: Dictionary) -> void:
	for __key: String in __dict.keys():
		self.set(__key, __dict[__key])

func flush_id() -> void:
	self.id = RandomString.new("P_").value

@abstract
func get_type_as_string() -> StringName
