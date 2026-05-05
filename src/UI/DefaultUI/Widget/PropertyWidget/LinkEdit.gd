# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# LinkEdit.gd
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

extends PropertyWidget
class_name LinkEditWidget

@export var from_id: LineEdit
@export var to_id: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Link = __property
	related_id = __prop.id
	from_id.text = __prop.from_id
	to_id.text = __prop.to_id
	for __control: LineEdit in [from_id, to_id]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: LineEdit in [from_id, to_id]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __from: String = from_id.text.strip_edges().strip_escapes()
	var __to: String = to_id.text.strip_edges().strip_escapes()
	return Link.new(__to, __from)
