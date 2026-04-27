extends PropertyWidget
class_name DescriptorEditWidget

func deserialize(__property: Property) -> void:
	var __prop: Descriptor = __property
	related_prop_id = __prop.id
	%LINE_ALIAS.set_text(__prop.alias)
	%LINE_PRIORITY.set_text(str(__prop.priority))
	for __control: Control in [%LINE_ALIAS, %LINE_PRIORITY]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

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
	for __control: Control in [%LINE_ALIAS, %LINE_PRIORITY]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	return __changed > 0

func get_as_property() -> Property:
	var __alias: String = %LINE_ALIAS.text.to_snake_case()
	var __priority: int = %LINE_PRIORITY.text.to_int()
	return Descriptor.new(__alias, __priority)

func trigger_options() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.MENU,
		&"dialog.item_properties.property_menu"
	))
