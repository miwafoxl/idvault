extends Resource
class_name DefaultUI_ItemHolder

@export var item: Item

const list_collapsible_head: PackedScene = preload(
	"res://scn/DefaultUI/Widgets/ListCollapsibleHead.tscn"
)

func _init(__item: Item) -> void:
	self.item = __item

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
