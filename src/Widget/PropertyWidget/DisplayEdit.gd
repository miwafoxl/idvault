extends PropertyWidget
class_name DisplayEditWidget

@export var lineedit_title: LineEdit
@export var lineedit_alt: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Display = __property
	related_prop_id = __prop.id
	lineedit_title.text = __prop.text
	lineedit_alt.text = __prop.alt

func get_as_property() -> Property:
	var __title: String = lineedit_title.text.strip_edges().strip_escapes()
	var __alt: String = lineedit_alt.text.strip_edges().strip_escapes()
	return Display.new(__title, __alt)
