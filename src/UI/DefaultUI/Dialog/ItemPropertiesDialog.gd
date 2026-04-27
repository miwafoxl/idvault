extends DefaultUI_Dialog
class_name DefaultUI_ItemPropertiesDialog

#region OVERRIDES

func enter_request() -> void:
	var __focus: Control = self.gui_get_focus_owner()
	if not __focus == %BUT_APPLY or __focus == null: return
	var __new_property: Dictionary = %EDITABLELIST.collect_item_node_data()
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"property.edit.apply", __new_property
	))
	handle_close_request.emit(alias)

func close_request(__confirm: bool = false) -> void:
	var __new_property: Dictionary = %EDITABLELIST.collect_item_node_data()
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
	%EDITABLELIST.contents = [DefaultUI_ItemHolder.new(__item)]
	%EDITABLELIST.reload_contents()
	if not %EDITABLELIST.trigger.is_connected(trigger.emit):
		%EDITABLELIST.trigger.connect(trigger.emit)

func _on_button_apply_button_down() -> void:
	enter_request()

func _on_but_property_add_pressed() -> void:
	var __item: Item = args.get("item")
	if __item == null:
		printerr("ItemPropertiesDialog: item parameter not received")
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.MENU,
		&"property.add_property",
		{
			"item_id": __item.id,
		}
	))

#endregion INPUT
