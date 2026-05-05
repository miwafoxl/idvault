# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# PropertyEdit.gd
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

extends DefaultUI_Widget
class_name PropertyEdit

@export var editing_item_id: String
@export var spawn_node: Control

@export var descriptor_edit: PackedScene
@export var display_edit: PackedScene

func deserialize_properties(__item_id: String, \
		__properties: Array[Property]) -> void:
	editing_item_id = __item_id
	for __node: Control in spawn_node.get_children():
		__node.queue_free()
	if __properties.is_empty(): 
		printerr("PropertyEditWidget: received no properties")
	for __prop: Property in __properties:
		var __scn: PropertyWidget
		if __prop is Descriptor:
			__scn = descriptor_edit.instantiate()
		elif __prop is Display:
			__scn = display_edit.instantiate()
		else:
			printerr("PropertyEditWidget: unknown prop type of prop id %s" % __prop.id)
		if __scn == null: continue
		__scn.related_id = __prop.id
		__scn.deserialize(__prop)
		__scn.trigger.connect(trigger.emit)
		spawn_node.add_child(__scn)

func get_properties_as_dict(__property_edit: Array[Node] = \
		spawn_node.get_children(true)) -> Dictionary:
	var __dict: Dictionary = {}
	var __mod: Dictionary = {}
	var __rem: Dictionary = {}
	var __add: Dictionary = {}
	var __add_arr: Array[Property] = []
	var __rem_arr: Array[String] = []
	var __changed: bool = false
	for __prop_edit: PropertyWidget in __property_edit as Array[PropertyWidget]:
		if __prop_edit.related_id.is_empty():
			__add_arr.append(__prop_edit.get_as_property())
			__changed = true
		else:
			if __prop_edit.marked_for_deletion:
				__rem_arr.append(__prop_edit.related_id)
				__changed = true
			if not __prop_edit.check_if_changed(): continue
			__mod.set(__prop_edit.related_id, __prop_edit.get_as_property())
			__changed = true
	if __changed:
		__add.set(editing_item_id, __add_arr)
		__rem.set(editing_item_id, __rem_arr)
		__dict = {
			"add": __add,
			"mod": __mod,
			"rem": __rem
		}
	return __dict
