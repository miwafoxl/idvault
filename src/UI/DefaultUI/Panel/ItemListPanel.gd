extends DefaultUI_Panel
class_name DefaultUI_ItemListPanel

@export var widget_item: PackedScene
@export var items_ref: Array[Item] = []
@export var selected_item_id: Array[String] = []

func interaction_item_display_click(__item_id: String) -> void:
	var __action: StringName
	if selected_item_id.is_empty():
		__action = &"items.select.by_item_id"
	else:
		if KeyboardModifiers.is_shift_modifier:
			if __item_id in selected_item_id:
				__action = &"items.deselect.by_item_id"
			else:
				__action = &"items.select.by_item_id_append"
		else:
			__action = &"items.select.by_item_id"
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		__action, {"item_id": [__item_id]}
	))

func update(__selected_items_id: Array[String] = []) -> void:
	update_item_display()
	update_selected_items(__selected_items_id)

func update_selected_items(__selected: Array[String] = []) -> void:
	selected_item_id = __selected
	for __item_widget: ItemDisplayWidget in %VBOX_C.get_children(false):
		if __item_widget.related_id in __selected:
			__item_widget.display_selected = true
		else:
			__item_widget.display_selected = false
		__item_widget.update_color()

func update_item_display() -> void:
	for __item: ItemDisplayWidget in %VBOX_C.get_children(false):
		__item.queue_free()
	for __stage_id: int in items_ref.size():
		var __item: Item = items_ref[__stage_id]
		var __item_widget: ItemDisplayWidget = widget_item.instantiate()
		var __item_title: Array[Display] = __item.retrieve_displays()
		__item_widget.related_stage_id = __stage_id
		__item_widget.related_id = __item.id
		if not __item_title.is_empty():
			__item_widget.title = __item_title[0].header
			__item_widget.subtitle = __item_title[0].alt
		else:
			__item_widget.title = str(__item.id)
		__item_widget.trigger.connect(trigger.emit)
		__item_widget.update()
		%VBOX_C.add_child(__item_widget)

func _on_new_item_button_button_down() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.MENU,
		&"items.add_item"
	))
	
func _on_query_button_button_down() -> void:
	if not %LINE_QUERY.text.is_empty():
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.stage.query", {"query": %LINE_QUERY.text.strip_edges()}
		))
	else:
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.stage.alphabetical", {}
		))
