extends DefaultUI_Panel
class_name DefaultUI_ItemOverview

@export var items_ref: Array[Item] = []
@export var selected: int = 0

func update() -> void:
	var __count: int = items_ref.size()
	if __count > 0:
		selected = selected % __count
	else:
		selected = 0
	update_counter(__count)
	update_view()

func update_view(__selected: int = selected) -> void:
	if items_ref.is_empty(): return
	var __item: Item = items_ref[selected]
	for __control: Control in [%BOX_C_DISPLAY, %BOX_C_DESC_CONTENT, %BOX_C_DESCR_VIEW]:
		__control.set_visible(false)
	if __item.properties.is_empty(): return
	for __prop: Property in __item.properties:
		match __prop.get_type_as_string():
			&"PROPERTY.TYPES.DISPLAY":
				var __display: Display = __prop
				%TXT_HEADER.set_text(__display.text)
				%TXT_ALT.set_text(__display.alt)
				%BOX_C_DISPLAY.set_visible(true)
			&"PROPERTY.TYPES.DESCRIPTOR":
				var __descriptor: Descriptor = __prop
				var __content: String = __descriptor.long
				if __content.is_empty(): continue
				%TXT_CONTENT.set_text(__content)
				%BOX_C_DESC_CONTENT.set_visible(true)
				
func update_counter(__count: int) -> void:
	if __count > 0:
		%TXT_INFO.set_text("%s/%s" % [selected + 1, __count])
	else:
		%TXT_INFO.set_text("")
