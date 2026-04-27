extends PropertyWidget
class_name DisplayEditWidget

@export var title: LineEdit
@export var alt: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Display = __property
	related_prop_id = __prop.id
	%LINE_HEADER.set_text(__prop.header)
	%LINE_ALT.set_text(__prop.alt)
	%LINE_BRIEF.set_text(__prop.brief)
	%LINE_TEXT.set_text(__prop.text)
	for __control: Control in [%LINE_HEADER, %LINE_ALT, \
								%LINE_BRIEF, %LINE_TEXT]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [%LINE_HEADER, %LINE_ALT, \
								%LINE_BRIEF, %LINE_TEXT]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __title: String = %LINE_HEADER.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __alt: String = %LINE_ALT.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __brief: String = %LINE_BRIEF.text \
		.strip_edges() \
		.strip_escapes() \
		.left(150)
	var __text: String = %LINE_TEXT.text \
		.left(1500)
	return Display.new(__title, __alt, __brief, __text)

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
