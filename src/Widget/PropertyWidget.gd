@abstract
extends Widget
class_name PropertyWidget

var related_prop_id: String = ""

@abstract
func get_as_property() -> Property

@abstract
func deserialize(__property: Property) -> void
