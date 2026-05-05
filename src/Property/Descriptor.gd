# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Descriptor.gd
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
class_name Descriptor

@export var alias: String = "" # Required: Lowercase, no symbols or spaces
@export var priority: int = 0

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DESCRIPTOR"

func _init(__alias: String = "", __priority: int = 0) -> void:
	self.alias = __alias
	self.priority = __priority
	super.flush_id()
