# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# DescriptorEdit.gd
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
class_name DescriptorEditWidget

func deserialize(__property: Property) -> void:
	var __prop: Descriptor = __property
	related_id = __prop.id
	%LINE_ALIAS.set_text(__prop.alias)
	%LINE_PRIORITY.set_text(str(__prop.priority))
	for __control: Control in [%LINE_ALIAS, %LINE_PRIORITY]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [%LINE_ALIAS, %LINE_PRIORITY]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __alias: String = %LINE_ALIAS.text.to_snake_case()
	var __priority: int = %LINE_PRIORITY.text.to_int()
	return Descriptor.new(__alias, __priority)
