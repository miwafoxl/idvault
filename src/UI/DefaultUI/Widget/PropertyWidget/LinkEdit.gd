extends PropertyWidget
class_name LinkEditWidget

@export var from_id: LineEdit
@export var to_id: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Link = __property
	related_prop_id = __prop.id
	from_id.text = __prop.from_id
	to_id.text = __prop.to_id
	for __lineedit: LineEdit in [from_id, to_id]:
		__lineedit.set_meta(UNCHANGED_META_STR, __lineedit.text)

func check_if_changed() -> bool:
	var __changed: bool = false
	for __lineedit: LineEdit in [from_id, to_id]:
		if not __lineedit.get_meta(UNCHANGED_META_STR) == __lineedit.text:
			__changed = true
	return __changed

func get_as_property() -> Property:
	var __from: String = from_id.text.strip_edges().strip_escapes()
	var __to: String = to_id.text.strip_edges().strip_escapes()
	return Link.new(__to, __from)

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
