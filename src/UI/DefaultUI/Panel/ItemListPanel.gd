# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# ItemListPanel.gd
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
class_name DefaultUI_ItemListPanel

@export var widget_item: PackedScene
@export var items_ref: Array[Item] = []
@export var selected_item_id: Array[String] = []
@export var selected_page: int = 0
@export var total_pages: int = 0
@export var sort_mode: SortTypes = SortTypes.ITEM_DISPLAY

const TAG_SELECTED_ITEM_IDS: String = "itemlist:selected_item_id"
const TAG_STAGED_ITEMS_PAGE: String = "itemlist:staged_items_page"

enum SortTypes {
	ITEM_ID,
	ITEM_DISPLAY,
	ITEM_SORT_NAME,
}

#region OVERRIDES

func _ready() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.FETCH,
		&"selected_id", {
			"_tag": TAG_SELECTED_ITEM_IDS,
		}
	))
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.FETCH,
		&"staged_items_page", {
			"_tag": TAG_STAGED_ITEMS_PAGE,
			"page_size": 100,
			"page_index": selected_page
		}
	))

func receive_fetch(__fetch_res: Dictionary) -> void:
	match __fetch_res.keys()[0]:
		TAG_SELECTED_ITEM_IDS:
			var __value: Array[String] = __fetch_res.values()[0]
			selected_item_id = __value
			update_selected_items(selected_item_id)
		TAG_STAGED_ITEMS_PAGE:
			var __value: Dictionary = __fetch_res.values()[0]
			total_pages = __value.get("total_pages", 0)
			items_ref = __value.get("items", [])
			update_item_display(sort_mode)

func update_selection() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.FETCH,
		&"selected_id", {
			"_tag": TAG_SELECTED_ITEM_IDS,
		}
	))

#endregion OVERRIDES

#func interaction_item_display_click(__item_id: String) -> void:
	#var __action: StringName
	#if selected_item_id.is_empty():
		#__action = &"items.select.by_item_id"
	#else:
		#if KeyboardModifiers.is_shift_modifier:
			#if __item_id in selected_item_id:
				#__action = &"items.deselect.by_item_id"
			#else:
				#__action = &"items.select.by_item_id_append"
		#else:
			#__action = &"items.select.by_item_id"
	#trigger.emit(Trigger.new(
		#Trigger.TriggerTypes.ACTION,
		#__action, {"item_id": [__item_id]}
	#))

func update() -> void:
	pass

func update_selected_items(__selected: Array[String] = []) -> void:
	selected_item_id = __selected
	for __item_widget: ItemDisplayWidget in %VBOX_C.get_children(false):
		if __item_widget.related_id in __selected:
			__item_widget.display_selected = true
		else:
			__item_widget.display_selected = false
		__item_widget.update_color()

func update_item_display(__sort: SortTypes = SortTypes.ITEM_SORT_NAME, \
		__reverse: bool = false) -> void:
	var __display_widget: Array[ItemDisplayWidget] = []
	for __item: ItemDisplayWidget in %VBOX_C.get_children(false):
		__item.queue_free()
	for __stage_id: int in items_ref.size():
		var __item: Item = items_ref[__stage_id]
		var __item_widget: ItemDisplayWidget = widget_item.instantiate()
		var __item_display: Array[Display] = __item.retrieve_displays()
		var __item_title: Display = __item_display[0]
		__item_widget.related_stage_id = __stage_id
		__item_widget.related_id = __item.id
		if __item_display.is_empty():
			__item_widget.set_name(__item.id)
			__item_widget.title = __item.id
		else:
			var __node_name: String = ""
			__item_widget.title = __item_title.header
			__item_widget.subtitle = __item_title.alt
			match __sort:
				SortTypes.ITEM_DISPLAY:
					__node_name = ("%s_%s" % [__item_title.get_any_valid_str(), __item.id]) \
					.validate_node_name()
				SortTypes.ITEM_SORT_NAME:
					__node_name = ("%s_%s" % [__item_title.sort_name, __item.id]) \
					.validate_node_name()
				_:
					__node_name = __item.id
			__item_widget.set_name(__node_name)
		__item_widget.trigger.connect(trigger.emit)
		__item_widget.update()
		__display_widget.append(__item_widget)
	__display_widget.sort()
	if not __reverse: __display_widget.reverse()
	for __display: ItemDisplayWidget in __display_widget:
		%VBOX_C.add_child(__display)

func _on_new_item_button_button_down() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.UI_REQUEST,
		&"menu:items.add_item"
	))
	
func _on_query_button_button_down() -> void:
	if not %LINE_QUERY.text.is_empty():
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.stage.query", {"query": %LINE_QUERY.text.strip_edges()}
		))
	else:
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.stage.alphabetical", {}
		))
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.FETCH,
		&"staged_items_page", {
			"_tag": TAG_STAGED_ITEMS_PAGE,
			"page_size": 100,
			"page_index": selected_page
		}
	))
