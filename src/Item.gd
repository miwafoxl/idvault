extends Resource
class_name Item

@export var id: int = 0;
@export var properties: Array[Property] = [];
# TODO: add Dictionary[property_id: weakref(Property)] to optimize line 34

func _init(__id: int, __properties: Array[Property] = []) -> void:
	self.id = __id
	self.properties = __properties

func append_proprieties(__properties: Array[Property]) -> bool:
	if not __properties.is_empty():
		properties.append_array(__properties)
		return true
	return false

func remove_proprieties_index(__rm_properties_idx: Array[int]) -> bool:
	var __prop_size: int = properties.size()
	if not __rm_properties_idx.is_empty():
		for __property_idx: int in __rm_properties_idx:
			if __property_idx > __prop_size: 
				printerr("Failed to remove property %s by index (larger than \
				properties size (%s))" % [__property_idx, __prop_size])
				return false
			properties.set(__property_idx, null)
		clean_properties()
	return true

func remove_proprieties(__rm_properties_id: Array[String]) -> void:
	var __prop_size: int = properties.size()
	if not __rm_properties_id.is_empty():
		for __rm_property_id: String in __rm_properties_id:
			for i: int in properties.size():
				var __property: Property = properties[i]
				if __property.id == __rm_property_id:
					properties.set(i, null)
		clean_properties()

func clean_properties() -> void:
	var __rm_indexes: Array[int] = []
	for __property_id: int in properties.size():
		if properties[__property_id] == null:
			__rm_indexes.append(__property_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		properties.remove_at(__index)

func has_descriptor() -> bool:
	for __prop: Property in properties:
		if __prop is Descriptor:
			return true
	return false

func retrieve_descriptors() -> Array[Descriptor]:
	var __properties_filtered: Array[Descriptor] = []
	for __prop: Property in properties:
		if __prop is Descriptor:
			__properties_filtered.append(__prop)
	return __properties_filtered

func has_link() -> bool:
	for __prop: Property in properties:
		if __prop is Link:
			return true
	return false

func retrieve_links() -> Array[Link]:
	var __properties_filtered: Array[Link] = []
	for __prop: Property in properties:
		if __prop is Link:
			__properties_filtered.append(__prop)
	return __properties_filtered

func count_parameters() -> int:
	var __count: int = 0
	for __prop: Property in properties:
		if __prop is Parameter:
			__count += 1
	return __count
	
func has_parameters() -> bool:
	for __prop: Property in properties:
		if __prop is Parameter:
			return true
	return false
	
func retrieve_parameters(__order: int = -1) -> Array[Parameter]:
	var __properties_filtered: Array[Parameter] = []
	for __prop: Property in properties:
		if __prop is Parameter:
			if (__order >= 0) and __prop.order == __order:
				__properties_filtered.append(__prop)
			else:
				__properties_filtered.append(__prop)
	return __properties_filtered

func has_display() -> bool:
	for __prop: Property in properties:
		if __prop is Display:
			return true
	return false

func retrieve_displays() -> Array[Display]:
	var __properties_filtered: Array[Display] = []
	for __prop: Property in properties:
		if __prop is Display:
			__properties_filtered.append(__prop)
	return __properties_filtered
