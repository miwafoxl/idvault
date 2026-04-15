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

func collect_item_node_data() -> Dictionary:
	var __data: Dictionary = {}
	for __node: Control in BODY.get_children():
		if __node is DefaultUI_ListCollapsibleHead:
			var __head: DefaultUI_ListCollapsibleHead = __node
			__data.merge(__head.collect_data())
	return __data

func reload_contents(__contents: Array = contents) -> void:
	unload_all_nodes()
	for __res: Resource in contents:
		display_item_node(__res)
