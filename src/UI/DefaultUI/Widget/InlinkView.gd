# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# InlinkView.gd
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

extends BoxContainer
class_name DefaultUI_InlinkView

@export var descriptor_button: PackedScene
@export var item_network: Dictionary
@export var match_type: String # empty, item, descriptor, property

func build() -> void:
	match match_type:
		"descriptor":
			clear()
			build_descriptor()
		"property":
			pass
		_:
			pass

func build_descriptor() -> void:
	if item_network.is_empty(): return
	var __but_nodes: Array[DefaultUI_InlinkButton]
	for __key: String in item_network.keys():
		# Get the dictionary from the item network dictionary,
		# checks if it is a descriptor.
		var __desc_dict: Dictionary = item_network[__key]
		if __desc_dict.get("type", "") != match_type: continue
		# Gets the item's descriptors.
		var __linking_item: Item = __desc_dict.get("linking_item", null)
		var __descriptors: Array[Descriptor] = __linking_item.retrieve_descriptors()
		# Creates the button node and gives it relevant values.
		var __but: DefaultUI_InlinkButton = descriptor_button.instantiate()
		__but.count = __desc_dict.get("linking_linkcount", 0)
		__but.linker_item = __desc_dict.get("linker_item", null)
		__but.related_item = __linking_item
		# Go through the item's descriptors, checks if the id given
		# by the item_network is an alias (that means the item has at
		# least one more descriptor). Renames the node using priority.
		for i in __descriptors.size():
			var __desc: Descriptor = __descriptors[i]
			if i == 0 and __desc.id != __key:
				__but.alias = __desc.alias
				__but.set_name("%s_%s" % [__desc.priority, __desc.alias])
			elif __desc.id == __key:
				__but.title = __desc.alias
				__but.set_name("%s_%s" % [__desc.priority, __desc.alias])
		# Updates the button content (handled internally).
		__but.update()
		__but_nodes.append(__but)
	# Sort nodes using the renamed node before adding them to spawn node.
	__but_nodes.sort_custom(func(__a: Control, __b: Control):
		return __a.name.naturalnocasecmp_to(__b.name) > 0)
	# Add sorted nodes to spawn node.
	for __but: DefaultUI_InlinkButton in __but_nodes:
		%HFLOW_C.add_child(__but)
	# Give text header the count of visualized buttons.
	%TXT_HEADER.set_text(tr(&"PANEL.ITEM_OVERVIEW.INLINKS_DESCRIPTOR_COUNT")
		.format({"count": __but_nodes.size()}))

func clear() -> void:
	%TXT_HEADER.set_text("")
	for __control: Control in %HFLOW_C.get_children():
		if __control is DefaultUI_InlinkButton:
			__control.queue_free()
