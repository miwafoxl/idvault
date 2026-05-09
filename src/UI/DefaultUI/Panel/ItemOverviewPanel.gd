# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# ItemOverviewPanel.gd
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

extends DefaultUI_Panel
class_name DefaultUI_ItemOverview

@export var items_ref: Array[Item] = []
@export var items_network: Dictionary = {}
@export var selected: int = 0

const TAG_SELECTED_ITEMS: String = "itemoverview:selected_items"

func receive_fetch(__fetch_res: Dictionary) -> void:
	match __fetch_res.keys()[0]:
		TAG_SELECTED_ITEMS:
			var __value: Dictionary = __fetch_res.values()[0]
			items_ref = __value.get("items", [])
			items_network = __value.get("network", {})
			update()

func update() -> void:
	var __count: int = items_ref.size()
	if __count > 0:
		selected = selected % __count
	else:
		selected = 0
	update_counter(__count)
	update_view()

func update_selection() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.FETCH,
		&"selected_items", {
			"_tag": TAG_SELECTED_ITEMS
		}
	))

func update_view(__selected: int = selected) -> void:
	if items_ref.is_empty(): return
	var __item: Item = items_ref[selected]
	for __control: Control in [%BOX_C_DISPLAY, %BOX_C_DESC_CONTENT, 
								%TXT_ALT]:
		__control.set_visible(false)
	if __item.properties.is_empty(): return
	for __prop: Property in __item.properties:
		match __prop.get_type_as_string():
			&"PROPERTY.TYPES.DISPLAY":
				var __display: Display = __prop
				if not __display.header == "":
					%TXT_HEADER.set_text(__display.header)
					%TXT_HEADER.set_visible(true)
				if not __display.alt == "":
					%TXT_ALT.set_text(__display.alt)
					%TXT_ALT.set_visible(true)
				if not __display.text == "":
					%TXT_CONTENT.set_text(__display.text)
					%BOX_C_DESC_CONTENT.set_visible(true)
				%TXT_ALT.set_text(__display.alt)
				%BOX_C_DISPLAY.set_visible(true)
			&"PROPERTY.TYPES.DESCRIPTOR":
				var __descriptor: Descriptor = __prop
	# Builds descriptor view.
	%BOX_C_INLINK_VIEW.item_network = items_network
	%BOX_C_INLINK_VIEW.build()

func update_counter(__count: int) -> void:
	if __count > 0:
		%TXT_INFO.set_text("%s/%s" % [selected + 1, __count])
	else:
		%TXT_INFO.set_text("")
