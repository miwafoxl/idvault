extends PropertyWidget
class_name DisplayEditWidget

@export var title: LineEdit
@export var alt: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Display = __property
	related_prop_id = __prop.id
	title.text = __prop.text
	alt.text = __prop.alt
	for __control: LineEdit in [title, alt]:
		__control.set_meta(&"unchanged", __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [title, alt]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __title: String = title.text.strip_edges().strip_escapes()
	var __alt: String = alt.text.strip_edges().strip_escapes()
	return Display.new(__title, __alt)

func collect() -> Dictionary:
	var __collected: Dictionary = {}
	if marked_for_deletion:
		__collected = {"rem": {
			related_prop_id: marked_for_deletion
		}}
	elif check_if_changed():
		__collected = {"mod": {
			related_prop_id: get_as_property().deserialized(false)
		}}
	return __collected
