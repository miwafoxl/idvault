@abstract
extends DefaultUI_Widget
class_name PropertyWidget

const UNCHANGED_META_STR: StringName = &"unchanged"

var related_prop_id: String = ""
var marked_for_deletion: bool = false
var changed: bool = false

@abstract
func get_as_property() -> Property

@abstract
func deserialize(__property: Property) -> void

@abstract
func check_if_changed() -> bool

func collect() -> Dictionary:
	var __collected: Dictionary = {}
	if marked_for_deletion:
		__collected = {"rm": {
			related_id: marked_for_deletion # Prop.id: bool
		}}
	elif marked_to_append:
		__collected = {"ap": {
			related_id: [get_as_property()] # Item.id: Array[Property]
		}}
	elif check_if_changed():
		__collected = {"md": {
			related_id: get_as_property().deserialized(false) # Prop.id: Dictionary
		}}
	return __collected
