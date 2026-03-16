extends UI_Panel
class_name PanelEntryList

@export var widget_entryitem: PackedScene
@export var entry_list_parent: Control
@export var items_ref: Array[Entry] = []

signal click(id: int)
signal hover(id: int)
signal add_entry
signal query(text: String)

func update() -> void:
	for __item: WidgetEntryItem in entry_list_parent.get_children(false):
		__item.queue_free()
	for __entry: Entry in items_ref:
		var __entry_widget: WidgetEntryItem = widget_entryitem.instantiate()
		var __entry_title: Array[Title] = __entry.retrieve_titles()
		__entry_widget.related_id = __entry.id
		if not __entry_title.is_empty():
			__entry_widget.title = __entry_title[0].text
			__entry_widget.subtitle = __entry_title[0].alt
		else:
			__entry_widget.title = str(__entry.id)
		__entry_widget.click.connect(click.emit.bind(__entry.id))
		__entry_widget.hover.connect(hover.emit.bind(__entry.id))
		__entry_widget.update()
		entry_list_parent.add_child(__entry_widget)


func _on_new_entry_button_button_down() -> void:
	add_entry.emit()

func _on_query_button_button_down() -> void:
	var __text: LineEdit = $VBoxContainer/HBoxContainer/QueryLine
	query.emit(__text.text.strip_edges())
