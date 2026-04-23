extends DefaultUI_Dialog
class_name DefaultUI_ItemPropertiesDialog

@export_category("INTERNAL NODES")
@export var editable_list: DefaultUI_EditableList

@export_category("GENERAL")
@export var label_item: Label

#region OVERRIDES

func enter_request() -> void:
	var __new_property: Dictionary = editable_list.collect_item_node_data()
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"property.edit.apply", __new_property
	))
	handle_close_request.emit(alias)

func close_request(__confirm: bool = false) -> void:
	var __new_property: Dictionary = editable_list.collect_item_node_data()
	if not __new_property.is_empty() and not __confirm:
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.UI_REQUEST,
			&"user_confirmation", {
				"callback": close_request.bind(true),
				"message": tr(&"DIALOG.USER_CONFIRMATION.EXIT_ITEM_PROPERTIES_UNCOMMITED_CHANGES")}
			))
	if __new_property.is_empty() or __confirm: 
		handle_close_request.emit(alias)

#endregion
#region INPUT

func _update_arguments() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	self.set_title(tr(&"DIALOG.ITEM_PROPERTIES.TITLE") + ": %s" % __item.id)
	editable_list.contents = [DefaultUI_ItemHolder.new(__item)]
	editable_list.reload_contents()
	if not editable_list.trigger.is_connected(trigger.emit):
		editable_list.trigger.connect(trigger.emit)

func _on_button_apply_button_down() -> void:
	enter_request()

#endregion INPUT
