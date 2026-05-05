# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# DefaultUI_ItemHolder.gd
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
class_name DefaultUI_ItemHolder

@export var item: Item

const list_collapsible_head: PackedScene = preload(
	"res://scn/DefaultUI/Widgets/ListCollapsibleHead.tscn"
)

func _init(__item: Item) -> void:
	self.item = __item

# TODO: Since there's a DefaultUI_PropertyHolder now, this doesn't make much sense because 
# now you can just do DefaultUI_PropertyHolder.new(item.properties[0]), though there's no support for
# arrays in that case.
func build_wd_list_collapsible_head() -> Array[DefaultUI_ListCollapsibleHead]:
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
			printerr("DefaultUI_ItemHolder: prop type '%s' has no integration with ListCollapsibleHead" % __prop_str)
			return null
		return __scn
	if item.properties.size() == 0:
		return []
	var __list_items: Array[DefaultUI_ListCollapsibleHead] = []
	for i: int in item.properties.size():
		var __prop: Property = item.properties[i]
		var __scn: PackedScene = __get_packed_scn.call(__prop)
		if __scn == null: continue
		var __node: PropertyWidget = __scn.instantiate()
		__node.deserialize(__prop)
		var __list_item: DefaultUI_ListCollapsibleHead = \
			list_collapsible_head.instantiate()
		__list_item.order = i
		__list_item.related_item_id = item.id
		__list_item.contents = __node
		__list_item.header_tr_string = __prop.get_type_as_string()
		__list_item.options_menu_id = &"menu:property.menu"
		__list_items.append(__list_item)
	return __list_items
