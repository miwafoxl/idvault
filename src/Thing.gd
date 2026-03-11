extends Resource
class_name Thing

@export var id: int = 0;
@export var elements: Array[Element] = [];

func append_elements(__elements: Array[Element]) -> bool:
	if not __elements.is_empty():
		elements.append_array(__elements)
		return true
	return false

func remove_elements(__elements: Array[int]) -> bool:
	var __elements_size: int = elements.size()
	if not __elements.is_empty():
		for __element_id: int in __elements:
			if __element_id < __elements_size: 
				printerr("Failed to remove element %s (larger than \
				elements size (%s))" % [__element_id, __elements_size])
				return false
			elements.remove_at(__element_id)
	return true

func new(__id: int, __elements: Array[Element] = []) -> Thing:
	self.id = __id
	self.elements = __elements
	return self
