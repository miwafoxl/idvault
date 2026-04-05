extends UI_Panel
class_name ItemListPanel

@export var widget_item: PackedScene
@export var item_list_parent: Control
@export var items_ref: Array[Item] = []
@export var selected_item_ids: Array[int] = []

signal add_item
signal query(text: String)
signal select_item(id: int)
signal deselect_item(id: int)
signal deselect_all()
signal select_item_append(id: int)

func interaction_item_display_click(__id: int) -> void:
	if KeyboardModifiers.is_shift_modifier:
		if __id in selected_item_ids:
			deselect_item.emit(__id)
		else:
			select_item_append.emit(__id)
	else:
		select_item.emit(__id)

func update(__selected_items_id: Array[int] = []) -> void:
	update_item_display()
	update_selected_items(__selected_items_id)

func update_selected_items(__selected: Array[int] = []) -> void:
	selected_item_ids = __selected
	for __item_widget: ItemDisplayWidget in item_list_parent.get_children(false):
		if __item_widget.related_id in __selected:
			__item_widget.display_selected = true
		else:
			__item_widget.display_selected = false
		__item_widget.update_color()

func update_item_display() -> void:
	for __item: ItemDisplayWidget in item_list_parent.get_children(false):
		__item.queue_free()
	for __item: Item in items_ref:
		var __item_widget: ItemDisplayWidget = widget_item.instantiate()
		var __item_title: Array[Display] = __item.retrieve_displays()
		__item_widget.related_id = __item.id
		if not __item_title.is_empty():
			__item_widget.title = __item_title[0].text
			__item_widget.subtitle = __item_title[0].alt
		else:
			__item_widget.title = str(__item.id)
		__item_widget.click.connect(interaction_item_display_click)
		__item_widget.request_menu.connect(request_menu.emit)
		__item_widget.update()
		item_list_parent.add_child(__item_widget)


func _on_new_item_button_button_down() -> void:
	add_item.emit()
	
func _on_query_button_button_down() -> void:
	var __text: LineEdit = $VBoxContainer/HBoxContainer/QueryLine
	query.emit(__text.text.strip_edges())
