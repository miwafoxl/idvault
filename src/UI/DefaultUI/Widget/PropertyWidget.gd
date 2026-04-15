@abstract
extends DefaultUI_Widget
class_name PropertyWidget

var related_prop_id: String = ""
var marked_for_deletion: bool = false
var changed: bool = false

@abstract
func get_as_property() -> Property

@abstract
func deserialize(__property: Property) -> void

@abstract
func check_if_changed() -> bool
