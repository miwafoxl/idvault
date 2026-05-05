# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# RangedEdit.gd
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
class_name RangedEditWidget

const DAYS_IN_MONTHS: Array[int] = [ 31,29,31,30,31,30,31,31,30,31,30,31 ]

@export var day_start: LineEdit
@export var day_end: LineEdit
@export var month_start: OptionButton
@export var month_end: OptionButton
@export var year_start: LineEdit
@export var year_end: LineEdit
@export var indefinite: CheckBox


func deserialize(__property: Property) -> void:
	var __prop: RangedDate = __property
	related_id = __prop.id
	indefinite.set_pressed(__prop.indefinite_end)
	# Day deserialize
	day_start.text = str(__prop.start_date.z) if __prop.start_date.z > 0 else ""
	day_end.text = str(__prop.end_date.z) if __prop.end_date.z > 0 else ""
	# Month deserialize
	month_start.select(__prop.start_date.y - 1)
	month_end.select(__prop.end_date.y - 1)
	# Year deserialize
	year_start.text = str(__prop.start_date.x) if __prop.start_date.x > 0 else ""
	year_end.text = str(__prop.end_date.x) if __prop.end_date.x > 0 else ""
	# Set unchanged values
	indefinite.set_meta(UNCHANGED_META_STR, indefinite.button_pressed)
	month_start.set_meta(UNCHANGED_META_STR, month_start.selected)
	month_end.set_meta(UNCHANGED_META_STR, month_end.selected)
	for __lineedit: Control in [day_start, day_end, year_start, year_end]:
		__lineedit.set_meta(UNCHANGED_META_STR, __lineedit.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	# Sums comparasions.
	for __lineedit: Control in [day_start, day_end, year_start, year_end]:
		__changed += int(__lineedit.get_meta(UNCHANGED_META_STR) != __lineedit.text)
	__changed += int(indefinite.get_meta(UNCHANGED_META_STR) != indefinite.button_pressed)
	__changed += int(month_start.get_meta(UNCHANGED_META_STR) != month_start.selected)
	__changed += int(month_end.get_meta(UNCHANGED_META_STR) != month_end.selected)
	return __changed > 0

# TODO: Make configurable when the user puts a number higher than the month currently
# set, either modulate to current month (%) or max out 
func get_as_property() -> Property:
	var __get_yyyymmdd: Callable = func(__day: int, __year: int, __month_selected: int) -> Vector3i:
		var __yyyymmdd: Vector3i = Vector3i.ZERO
		__yyyymmdd.x = __year
		__yyyymmdd.z = ((__day - 1) % DAYS_IN_MONTHS[__month_selected] + 1) \
				if __day == 0 or __day > DAYS_IN_MONTHS[__month_selected] \
				else __day
		__yyyymmdd.y = __month_selected + 1
		return __yyyymmdd
	var __start_yyyymmdd: Vector3i = __get_yyyymmdd.call(
		abs(day_start.text.strip_edges().strip_escapes().to_int()),
		abs(year_start.text.strip_edges().strip_escapes().to_int()),
		month_start.selected)
	var __end_yyyymmdd: Vector3i = __get_yyyymmdd.call(
		abs(day_end.text.strip_edges().strip_escapes().to_int()),
		abs(year_end.text.strip_edges().strip_escapes().to_int()),
		month_end.selected)
	return RangedDate.new([__start_yyyymmdd, __end_yyyymmdd], indefinite.button_pressed)

func set_disabled_end_date(__disabled: bool) -> void:
	day_end.set_editable(not __disabled)
	year_end.set_editable(not __disabled)
	month_end.set_disabled(__disabled)
