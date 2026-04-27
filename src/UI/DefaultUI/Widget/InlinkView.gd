extends BoxContainer
class_name DefaultUI_InlinkView

@export var descriptor_button: PackedScene
@export var item_network: Dictionary
@export var match_type: String # empty, item, descriptor, property
# {
# 	"type": __type,
# 	"linking_linkcount": __count,
# 	"linking_item": __item_ref.get_ref(),
# 	"linker_item_id": __linker_ref.get_ref()
# })

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
	var __but_count: int = 0
	for __key: String in item_network.keys():
		var __desc_dict: Dictionary = item_network[__key]
		if __desc_dict.get("type", "") != match_type: continue
		var __linking_item: Item = __desc_dict.get("linking_item", null)
		var __descriptors: Array[Descriptor] = __linking_item.retrieve_descriptors()
		var __but: DefaultUI_InlinkButton = descriptor_button.instantiate()
		__but.count = __desc_dict.get("linking_linkcount", 0)
		__but.linker_item = __desc_dict.get("linker_item", null)
		__but.related_item = __linking_item
		for i in __descriptors.size():
			var __desc: Descriptor = __descriptors[i]
			if i == 0 and __desc.id != __key:
				__but.alias = __desc.alias
			elif __desc.id == __key:
				__but.title = __desc.alias
		__but.update()
		__but_count += 1
		%HFLOW_C.add_child(__but)
	%TXT_HEADER.set_text(tr(&"PANEL.ITEM_OVERVIEW.INLINKS_DESCRIPTOR_COUNT").format({"count": __but_count}))

func clear() -> void:
	%TXT_HEADER.set_text("")
	for __control: Control in %HFLOW_C.get_children():
		if __control is DefaultUI_InlinkButton:
			__control.queue_free()
