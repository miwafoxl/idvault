extends Object

## Retrieves valid string from selected items and set them to clipboard,
## separated into spaces.
func run(__manager: ItemManager, __param: Dictionary) -> bool:
	var __display: PackedStringArray = []
	for __item: Item in __manager.selected_items:
		var __string: String = __item.get_valid_string_display_or_empty()
		if not __string.is_empty():
			__display.append(__string)
	if __display.is_empty():
		return false # TODO: Add global setting to limit the clipboard length
	DisplayServer.clipboard_set(" ".join(__display)) # TODO: Global setting to change " " here
	return true
