extends Resource
class_name Item

@export var id: int = 0;
@export var elements: Array[Element] = [];

func _init(__id: int, __elements: Array[Element] = []) -> void:
	self.id = __id
	self.elements = __elements

func append_elements(__elements: Array[Element]) -> bool:
	if not __elements.is_empty():
		elements.append_array(__elements)
		return true
	return false

func remove_elements(__elements: Array[int]) -> bool:
	var __elements_size: int = elements.size()
	if not __elements.is_empty():
		for __element_id: int in __elements:
			if __element_id > __elements_size: 
				printerr("Failed to remove element %s (larger than \
				elements size (%s))" % [__element_id, __elements_size])
				return false
			elements.set(__element_id, null)
		clean_elements()
	return true

func clean_elements() -> void:
	var __rm_indexes: Array[int] = []
	for __element_id: int in elements.size():
		if elements[__element_id] == null:
			__rm_indexes.append(__element_id)
	__rm_indexes.reverse()
	for __index: int in __rm_indexes:
		elements.remove_at(__index)

func has_descriptor() -> bool:
	for __element: Element in elements:
		if __element is Descriptor:
			return true
	return false

func retrieve_descriptors() -> Array[Descriptor]:
	var __elements_filtered: Array[Descriptor] = []
	for __element: Element in elements:
		if __element is Descriptor:
			__elements_filtered.append(__element)
	return __elements_filtered

func has_link() -> bool:
	for __element: Element in elements:
		if __element is Link:
			return true
	return false

func retrieve_links() -> Array[Link]:
	var __elements_filtered: Array[Link] = []
	for __element: Element in elements:
		if __element is Link:
			__elements_filtered.append(__element)
	return __elements_filtered

func count_parameters() -> int:
	var __count: int = 0
	for __element: Element in elements:
		if __element is Parameter:
			__count += 1
	return __count
	
func has_parameters() -> bool:
	for __element: Element in elements:
		if __element is Parameter:
			return true
	return false
	
func retrieve_parameters(__order: int = -1) -> Array[Parameter]:
	var __elements_filtered: Array[Parameter] = []
	for __element: Element in elements:
		if __element is Parameter:
			if (__order >= 0) and __element.order == __order:
				__elements_filtered.append(__element)
			else:
				__elements_filtered.append(__element)
	return __elements_filtered

func has_display() -> bool:
	for __element: Element in elements:
		if __element is Display:
			return true
	return false

func retrieve_displays() -> Array[Display]:
	var __elements_filtered: Array[Display] = []
	for __element: Element in elements:
		if __element is Display:
			__elements_filtered.append(__element)
	return __elements_filtered
