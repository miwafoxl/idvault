extends UI_Panel
class_name ItemListPanel

@export var widget_item: PackedScene
@export var item_list_parent: Control
@export var items_ref: Array[Item] = []

signal click(id: int)
signal hover(id: int)
signal add_item
signal query(text: String)

func update() -> void:
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
		__item_widget.click.connect(click.emit.bind(__item.id))
		__item_widget.hover.connect(hover.emit.bind(__item.id))
		__item_widget.update()
		item_list_parent.add_child(__item_widget)


func _on_new_item_button_button_down() -> void:
	add_item.emit()

func _on_query_button_button_down() -> void:
	var __text: LineEdit = $VBoxContainer/HBoxContainer/QueryLine
	query.emit(__text.text.strip_edges())
