extends PropertyWidget
class_name DisplayEditWidget

@export var lineedit_title: LineEdit
@export var lineedit_alt: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Display = __property
	related_prop_id = __prop.id
	lineedit_title.text = __prop.text
	lineedit_alt.text = __prop.alt
	for __lineedit: LineEdit in [lineedit_title, lineedit_alt]:
		__lineedit.set_meta(&"unchanged", __lineedit.text)

func check_if_changed() -> bool:
	var __changed: bool = false
	for __lineedit: LineEdit in [lineedit_title, lineedit_alt]:
		if not __lineedit.get_meta(&"unchanged") == __lineedit.text:
			__changed = true
	return __changed

func get_as_property() -> Property:
	var __title: String = lineedit_title.text.strip_edges().strip_escapes()
	var __alt: String = lineedit_alt.text.strip_edges().strip_escapes()
	return Display.new(__title, __alt)
