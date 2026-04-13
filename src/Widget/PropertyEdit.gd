extends Widget
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
		__scn.related_prop_id = __prop.id
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
		if __prop_edit.related_prop_id.is_empty():
			__add_arr.append(__prop_edit.get_as_property())
			__changed = true
		else:
			if __prop_edit.marked_for_deletion:
				__rem_arr.append(__prop_edit.related_prop_id)
				__changed = true
			if not __prop_edit.check_if_changed(): continue
			__mod.set(__prop_edit.related_prop_id, __prop_edit.get_as_property())
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
