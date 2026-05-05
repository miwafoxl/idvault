# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# EditableList.gd
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
class_name DefaultUI_EditableList
@export_category("INTERNAL NODES")
@export var BODY: VBoxContainer

@export_category("GENERAL")
@export var contents: Array

func unload_all_nodes() -> void:
	for __node: Control in BODY.get_children():
		if __node is DefaultUI_ListCollapsibleHead:
			__node.queue_free()

func display_item_node(__res: Resource) -> void:
	var __list_items: Array[DefaultUI_ListCollapsibleHead] = []
	var __build_body_method: StringName = &"build_wd_list_collapsible_head"
	if __res.has_method(__build_body_method):
		__list_items = __res.call(__build_body_method)
	if __list_items.is_empty():
		printerr("DefaultUI_EditableList: failed to build list " + \
		"for resource '%s' — doesn't implement '%s'" % [__res.to_string(), __build_body_method])
		return
	for __item: DefaultUI_ListCollapsibleHead in __list_items:
		__item.trigger.connect(trigger.emit)
		BODY.add_child(__item)

# TODO: __data.merge here will overwrite when merge, meaning that it's likely that 2 things can be
# added, removed or modified at once, each.
func collect_item_node_data() -> Dictionary:
	var __data: Dictionary = {}
	var __ap: Dictionary
	var __rm: Dictionary
	var __md: Dictionary
	for __node: Control in BODY.get_children():
		if __node is DefaultUI_ListCollapsibleHead:
			var __head: DefaultUI_ListCollapsibleHead = __node
			var __collected: Dictionary = __head.collect_data()
			for __key: String in __collected.keys():
				match __key:
					"ap":
						for __dict: Dictionary in __collected.values():
							var __hash: int = __dict.hash()
							__ap.set("ap#%s@%s" % [__hash, __dict.keys()[0]], __dict.values()[0])
					"md":
						for __dict: Dictionary in __collected.values():
							var __hash: int = __dict.hash()
							__md.set("md#%s@%s" % [__hash, __dict.keys()[0]], __dict.values()[0])
					"rm":
						for __dict: Dictionary in __collected.values():
							var __hash: int = __dict.hash()
							__rm.set("rm#%s@%s" % [__hash, __dict.keys()[0]], __dict.values()[0])
			#__data.merge(__head.collect_data())
	if __ap:
		__data.set("ap", __ap)
	if __rm:
		__data.set("rm", __rm)
	if __md:
		__data.set("md", __md)
	return __data

func reload_contents(__contents: Array = contents) -> void:
	unload_all_nodes()
	for __res: Resource in contents:
		display_item_node(__res)
