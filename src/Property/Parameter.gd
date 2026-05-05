# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Parameter.gd
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
class_name Parameter

@export var param_id: String = "";
@export var order: int = 0;
@export var type: ParameterTypes = ParameterTypes.PARAMETER;

enum ParameterTypes {
	PARAMETER,
	STRING,
	NUMBER,
}

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.PARAMETER"

func _init(__type: ParameterTypes = ParameterTypes.NUMBER, __order: int = 0, \
		__id: String = RandomString.new("p_").value):
	self.param_id = __id
	self.order = __order
	self.type = __type
	super.flush_id()
