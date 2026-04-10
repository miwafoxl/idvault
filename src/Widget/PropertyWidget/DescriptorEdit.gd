extends PropertyWidget
class_name DescriptorEditWidget

@export var lineedit_alias: LineEdit
@export var lineedit_short: LineEdit
@export var lineedit_long: TextEdit

func deserialize(__property: Property) -> void:
	var __prop: Descriptor = __property
	related_prop_id = __prop.id
	lineedit_alias.text = __prop.alias
	lineedit_short.text = __prop.short
	lineedit_long.text = __prop.long
	for __control: Control in [lineedit_alias, lineedit_short, lineedit_long]:
		__control.set_meta(&"unchanged", __control.text)

func check_if_changed() -> bool:
	var __changed: bool = false
	for __control: Control in [lineedit_alias, lineedit_short, lineedit_long]:
		if not __control.get_meta(&"unchanged") == __control.text:
			__changed = true
	return __changed

func get_as_property() -> Property:
	var __alias: String = lineedit_alias.text.to_snake_case()
	var __short: String = lineedit_short.text.strip_edges().strip_escapes()
	var __long: String = lineedit_long.text.strip_edges()
	return Descriptor.new(__alias, __short, __long)
