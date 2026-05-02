extends PropertyWidget
class_name LinkEditWidget

@export var from_id: LineEdit
@export var to_id: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Link = __property
	related_prop_id = __prop.id
	from_id.text = __prop.from_id
	to_id.text = __prop.to_id
	for __control: LineEdit in [from_id, to_id]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: LineEdit in [from_id, to_id]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __from: String = from_id.text.strip_edges().strip_escapes()
	var __to: String = to_id.text.strip_edges().strip_escapes()
	return Link.new(__to, __from)
