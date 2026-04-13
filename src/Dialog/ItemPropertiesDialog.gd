extends Dialog
class_name ItemPropertiesDialog

@export var label_item: Label
@export var property_edit: PropertyEdit

#region OVERRIDES

func enter_request() -> void:
	var __new_property: Dictionary = property_edit.get_properties_as_dict()
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"property.edit.apply", __new_property
	))
	self.queue_free()

func close_request(__confirm: bool = false) -> void:
	var __new_property: Dictionary = property_edit.get_properties_as_dict()
	if not __new_property.is_empty() and not __confirm:
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.DIALOG,
			&"user_confirmation", {
				"callback": close_request.bind(true),
				"message": tr(&"DIALOG.USER_CONFIRMATION.EXIT_ITEM_PROPERTIES_UNCOMMITED_CHANGES")}
			))
	if __new_property.is_empty() or __confirm: 
		self.queue_free()



#endregion
#region INPUT

func _on_about_to_popup() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	self.set_title(tr(self.title) + ": %s" % __item.id)
	property_edit.deserialize_properties(__item.id, __item.properties)
	property_edit.trigger.connect(trigger.emit)

func _on_button_apply_button_down() -> void:
	enter_request()

#endregion INPUT
