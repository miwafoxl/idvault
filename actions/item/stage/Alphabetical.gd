extends Object

func order(a: Item, b: Item) -> bool:
	var a_text: String = a.get_valid_string_display_or_empty()
	var b_text: String = b.get_valid_string_display_or_empty()
	if a_text.is_empty() and b_text.is_empty(): return false # i don't know man
	if a_text.is_empty() and !b_text.is_empty(): return false
	if !a_text.is_empty() and b_text.is_empty(): return true
	
	for i: int in a_text.length():
		var __a_char: int = a_text.unicode_at(i)
		for u: int in b_text.length():
			var __b_char: int = b_text.unicode_at(i)
			if __a_char > __b_char: return true
			else: return false
	return false

## Stage items in alphabetically
func run(__manager: Manager, __args: Array) -> bool:
	var __items: Array[Item] = []
	for __item: Variant in __args:
		if __item is Item:
			__items.append(__item as Item)
	if __items.is_empty():
		push_warning("items.stage.alphabetical: No items to stage")
		return false
	__items.sort_custom(order)
	__manager.stage_items(__items)
	__manager.reverse_staged()
	return true
