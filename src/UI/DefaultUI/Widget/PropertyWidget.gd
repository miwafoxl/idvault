# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# PropertyWidget.gd
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
extends DefaultUI_Widget
class_name PropertyWidget

const UNCHANGED_META_STR: StringName = &"unchanged"

var related_id: String = ""
var marked_for_deletion: bool = false
var marked_to_append: bool = false
var changed: bool = false

@abstract
func get_as_property() -> Property

@abstract
func deserialize(__property: Property) -> void

@abstract
func check_if_changed() -> bool

func collect() -> Dictionary:
	var __collected: Dictionary = {}
	if marked_for_deletion:
		__collected = {"rm": {
			related_id: marked_for_deletion # Prop.id: bool
		}}
	elif marked_to_append:
		__collected = {"ap": {
			related_id: [get_as_property()] # Item.id: Array[Property]
		}}
	elif check_if_changed():
		__collected = {"md": {
			related_id: get_as_property().deserialized(false) # Prop.id: Dictionary
		}}
	return __collected
