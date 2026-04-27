extends Resource
class_name Item

@export var id: String = ""
@export var properties: Array[Property] = [];
# TODO: add Dictionary[property_id: weakref(Property)] to optimize line 34

#region OVERRIDES

func _init(__id: String = "", __properties: Array[Property] = []) -> void:
	self.properties = __properties
	self.id = __id
	if __id.is_empty():
		self.id = RandomString.new("i_").value

#endregion OVERRIDES
#region ADD, REMOVE AND REORDER PROPERTIES

func append_properties(__properties: Array[Property]) -> bool:
	if not __properties.is_empty():
		properties.append_array(__properties)
		return true
	return false

func remove_properties_index(__rm_properties_idx: Array[int]) -> bool:
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

func remove_properties(__rm_properties_id: Array[String]) -> void:
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

func reorder_properties(__prop_idx: Array[int], __idx: int) -> void:
	var __prop_size: int = properties.size()
	var __new_idx: int = __idx
	var __temp: Array[Property] = []
	var __counter: int = 0
	for i: int in __prop_size:
		if i <= __new_idx and i > __new_idx + __prop_idx.size() - 1:
			__temp.append(properties[__counter])
			__counter += 1
		else:
			var __i: int = ((__new_idx + __prop_idx.size() - 1) - i) % __prop_size
			__temp.append(properties[__i])
			print("B: __i = %s" % __i)
	properties = __temp

#endregion ADD, REMOVE AND REORDER PROPERTIES
#region RETRIEVE PROPERTIES

func retrieve_property_ids() -> Array[String]:
	var __ids: Array[String] = []
	for __prop: Property in self.properties:
		__ids.append(__prop.id)
	return __ids

func has_property_id(__id: Array[String]) -> bool:
	var __property_ids: Array[String] = retrieve_property_ids()
	for __has_id: String in __id:
		if __has_id in __property_ids:
			return true
	return false

#region DESCRIPTOR

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

#endregion DESCRIPTOR
#region LINK

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

#endregion LINK
#region PARAMETER

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

#endregion PARAMETERS
#region DISPLAY

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

func get_valid_string_display_or_empty() -> String:
	var __displays: Array[Display] = retrieve_displays()
	for __display: Display in __displays:
		var __string: String = __display.get_any_valid_str()
		if not __string.is_empty(): return __string
	return ""

#endregion DISPLAY
#endregion RETRIEVE PROPERTIES
