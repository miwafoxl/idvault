extends PropertyWidget
class_name DescriptorEditWidget

@export var alias: LineEdit
@export var short: LineEdit
@export var long: TextEdit

func deserialize(__property: Property) -> void:
	var __prop: Descriptor = __property
	related_prop_id = __prop.id
	alias.text = __prop.alias
	short.text = __prop.short
	long.text = __prop.long
	for __control: Control in [alias, short, long]:
		__control.set_meta(&"unchanged", __control.text)

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

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [alias, short, long]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __alias: String = alias.text.to_snake_case()
	var __short: String = short.text.strip_edges().strip_escapes()
	var __long: String = long.text.strip_edges()
	return Descriptor.new(__alias, __short, __long)

func trigger_options() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.MENU,
		&"dialog.item_properties.property_menu"
	))
