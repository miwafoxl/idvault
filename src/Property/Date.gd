# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Date.gd
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
class_name Date

@export var description: String = ""
@export var yyyymmdd: Vector3i = Vector3i.ZERO;
@export var utc: int = 0;

# Get seconds since
func get_difference(__yyyymmdd: Vector3i) -> int:
	var __timestamp_1: int = Time.get_unix_time_from_datetime_dict({
		"year": yyyymmdd[0],
		"month": yyyymmdd[1],
		"day": yyyymmdd[2],
	})
	var __timestamp_2: int = Time.get_unix_time_from_datetime_dict({
		"year": __yyyymmdd[0],
		"month": __yyyymmdd[1],
		"day": __yyyymmdd[2],
	})
	return abs(__timestamp_2 - __timestamp_1)

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DATE"

func _init(__yyyymmdd: Vector3i = Vector3i.ZERO, __description: String = "", \
		__utc: int = 0) -> void:
	self.yyyymmdd = __yyyymmdd
	self.utc = __utc
	self.description = __description
	super.flush_id()
