# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# RangedDate.gd
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
class_name RangedDate

@export var description: String = ""
@export var start_date: Vector3i = Vector3i.ZERO;
@export var end_date: Vector3i = Vector3i.ZERO;
@export var indefinite_end: bool = false

func should_swap(__bound_1: Vector3i, __bound_2: Vector3i) -> bool:
	if __bound_1 < __bound_2 or __bound_2 == Vector3i.ZERO:
		return false
	return true

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.RANGED_DATE"

func _init(__range: Array[Vector3i] = [Vector3i.ZERO, Vector3i.ZERO], \
		__indefinite: bool = false) -> void:
	var __bound_1: Vector3i = __range[0];
	var __bound_2: Vector3i = __range[1];
	self.indefinite_end = __indefinite
	self.start_date = __bound_1
	self.end_date = __bound_2
	super.flush_id()
	if should_swap(__bound_1, __bound_2) and not __indefinite:
		self.start_date = __bound_2
		self.end_date = __bound_1
	
