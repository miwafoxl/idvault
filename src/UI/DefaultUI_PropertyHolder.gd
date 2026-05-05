# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# DefaultUI_PropertyHolder.gd
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

extends Resource
class_name DefaultUI_PropertyHolder

@export var property: Property
@export var related_item_id: String = ""
@export var marked_for_deletion: bool = false
@export var marked_to_append: bool = false

const LIST_COLLAPSIBLE_HEAD: PackedScene = preload(
	"res://scn/DefaultUI/Widgets/ListCollapsibleHead.tscn"
)

func _init(__property: Property, __item_id: String, \
		__append: bool = false, __delete: bool = false) -> void:
	self.property = __property
	self.related_item_id = __item_id
	self.marked_to_append = __append
	self.marked_for_deletion = __delete

func build_wd_list_collapsible_head() -> Array[DefaultUI_ListCollapsibleHead]:
	var __list_items: Array[DefaultUI_ListCollapsibleHead] = []
	var __get_packed_scn: Callable = func(__prop: Property) -> PackedScene:
		var __scn: PackedScene = null
		if __prop is Descriptor:
			__scn = preload("res://scn/DefaultUI/Widgets/PropertyWidget/DescriptorEdit.tscn")
		if __prop is Display:
			__scn = preload("res://scn/DefaultUI/Widgets/PropertyWidget/DisplayEdit.tscn")
		if __prop is Date:
			__scn = preload("res://scn/DefaultUI/Widgets/PropertyWidget/DateEdit.tscn")
		if __prop is RangedDate:
			__scn = preload("res://scn/DefaultUI/Widgets/PropertyWidget/RangedDateEdit.tscn")
		if __prop is Link:
			__scn = preload("res://scn/DefaultUI/Widgets/PropertyWidget/LinkEdit.tscn")
		if __scn == null:
			var __prop_str: StringName = __prop.get_type_as_string()
			printerr("DefaultUI_PropertyHolder: prop type '%s' has no integration with ListCollapsibleHead" % __prop_str)
			return null
		return __scn
	var __property_widget_scn: PackedScene = __get_packed_scn.call(property)
	var __node: PropertyWidget = __property_widget_scn.instantiate()
	var __list_item: DefaultUI_ListCollapsibleHead
	if __node == null: return __list_items
	__node.deserialize(property)
	__node.related_id = related_item_id
	__node.marked_for_deletion = marked_for_deletion
	__node.marked_to_append = marked_to_append
	__list_item = LIST_COLLAPSIBLE_HEAD.instantiate()
	__list_item.contents = __node
	__list_item.related_item_id = related_item_id
	__list_item.header_tr_string = property.get_type_as_string()
	__list_item.options_menu_id = &"menu:property.menu"
	__list_items.append(__list_item)
	return __list_items
