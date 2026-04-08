extends Widget
class_name PropertyEditWidget

@export var properties_remap: Dictionary[String, Property]
@export var spawn_node: Control

@export var descriptor_edit: PackedScene
@export var display_edit: PackedScene

func deserialize_properties(__properties: Array[Property]) -> void:
	for __node: Control in spawn_node.get_children():
		__node.queue_free()
	properties_remap.clear()
	if __properties.is_empty(): 
		printerr("PropertyEditWidget: received no properties")
	for __prop: Property in __properties:
		properties_remap.set(__prop.id, __prop)
		var __scn: PropertyWidget
		if __prop is Descriptor:
			__scn = descriptor_edit.instantiate()
		elif __prop is Display:
			__scn = display_edit.instantiate()
		else:
			printerr("PropertyEditWidget: unknown prop type of prop id %s" % __prop.id)
		if __scn == null: continue
		__scn.deserialize(__prop)
		spawn_node.add_child(__scn)
