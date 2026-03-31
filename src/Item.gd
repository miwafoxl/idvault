extends Resource
class_name Item

@export var id: int = 0;
@export var proprietes: Array[Property] = [];

func _init(__id: int, __proprietes: Array[Property] = []) -> void:
	self.id = __id
	self.proprietes = __proprietes

func append_proprieties(__proprietes: Array[Property]) -> bool:
	if not __proprietes.is_empty():
		proprietes.append_array(__proprietes)
		return true
	return false

func remove_proprieties(__rm_proprietes_id: Array[int]) -> bool:
	var __prop_size: int = proprietes.size()
	if not __rm_proprietes_id.is_empty():
		for __property_id: int in __rm_proprietes_id:
			if __property_id > __prop_size: 
				printerr("Failed to remove property %s (larger than \
				proprietes size (%s))" % [__property_id, __prop_size])
				return false
			proprietes.set(__property_id, null)
		clean_proprietes()
	return true

func clean_proprietes() -> void:
	var __rm_indexes: Array[int] = []
	for __property_id: int in proprietes.size():
		if proprietes[__property_id] == null:
			__rm_indexes.append(__property_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		proprietes.remove_at(__index)

func has_descriptor() -> bool:
	for __prop: Property in proprietes:
		if __prop is Descriptor:
			return true
	return false

func retrieve_descriptors() -> Array[Descriptor]:
	var __proprietes_filtered: Array[Descriptor] = []
	for __prop: Property in proprietes:
		if __prop is Descriptor:
			__proprietes_filtered.append(__prop)
	return __proprietes_filtered

func has_link() -> bool:
	for __prop: Property in proprietes:
		if __prop is Link:
			return true
	return false

func retrieve_links() -> Array[Link]:
	var __proprietes_filtered: Array[Link] = []
	for __prop: Property in proprietes:
		if __prop is Link:
			__proprietes_filtered.append(__prop)
	return __proprietes_filtered

func count_parameters() -> int:
	var __count: int = 0
	for __prop: Property in proprietes:
		if __prop is Parameter:
			__count += 1
	return __count
	
func has_parameters() -> bool:
	for __prop: Property in proprietes:
		if __prop is Parameter:
			return true
	return false
	
func retrieve_parameters(__order: int = -1) -> Array[Parameter]:
	var __proprietes_filtered: Array[Parameter] = []
	for __prop: Property in proprietes:
		if __prop is Parameter:
			if (__order >= 0) and __prop.order == __order:
				__proprietes_filtered.append(__prop)
			else:
				__proprietes_filtered.append(__prop)
	return __proprietes_filtered

func has_display() -> bool:
	for __prop: Property in proprietes:
		if __prop is Display:
			return true
	return false

func retrieve_displays() -> Array[Display]:
	var __proprietes_filtered: Array[Display] = []
	for __prop: Property in proprietes:
		if __prop is Display:
			__proprietes_filtered.append(__prop)
	return __proprietes_filtered
