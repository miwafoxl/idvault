# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Display.gd
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
class_name Display

@export var header: String = "";
@export var alt: String = "";
@export var brief: String = "";
@export var text: String = "";
@export var iso_639_1: String = "";

func get_any_valid_str() -> String:
	var __strings: Array[String] = [header, alt, brief, text]
	for __text: String in __strings:
		if not __text.is_empty(): 
			return __text.left(150)
	return ""

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DISPLAY"

func _init(__header: String = "", __alt: String = "", __brief: String = "", \
		__text: String = "", __iso_639_1: String = "") -> void:
	self.header = __header
	self.alt = __alt
	self.text = __text
	self.brief = __brief
	self.iso_639_1 = __iso_639_1
	super.flush_id()
