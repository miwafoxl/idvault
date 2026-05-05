# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# DisplayEdit.gd
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
class_name DisplayEditWidget

@export var title: LineEdit
@export var alt: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Display = __property
	related_id = __prop.id
	%LINE_HEADER.set_text(__prop.header)
	%LINE_ALT.set_text(__prop.alt)
	%LINE_BRIEF.set_text(__prop.brief)
	%LINE_TEXT.set_text(__prop.text)
	for __control: Control in [%LINE_HEADER, %LINE_ALT, \
								%LINE_BRIEF, %LINE_TEXT]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [%LINE_HEADER, %LINE_ALT, \
								%LINE_BRIEF, %LINE_TEXT]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __title: String = %LINE_HEADER.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __alt: String = %LINE_ALT.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __brief: String = %LINE_BRIEF.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __text: String = %LINE_TEXT.text \
		.left(1500)
	return Display.new(__title, __alt, __brief, __text)
