extends Dialog
class_name ItemPropertiesDialog

@export var label_item: Label
@export var property_edit: PropertyEditWidget

func _on_about_to_popup() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	self.set_title(tr(self.title) + ": %s" % __item.id)
	property_edit.deserialize_properties(__item.properties)
