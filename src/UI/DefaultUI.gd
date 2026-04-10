extends UI
class_name DefaultUI

@export var manager: ItemManager
@export var node_panels: Control

signal request_menu(menu_id: StringName, param: Dictionary)

func update() -> void:
	update_panels()

func update_selection() -> void:
	update_panels()

func give_managers(__managers: Dictionary) -> void:
	for __key: String in __managers:
		match __key:
			"item":
				manager = __managers[__key]
			_:
				printerr("UI: unknown manager '%s' provided to UI" % __key)

func update_panels() -> void:
	for panel: Control in node_panels.get_children():
		if (panel is UI_Panel) and (panel is ItemListPanel):
			(panel as ItemListPanel).items_ref = manager.get_staged_items_pages()
			(panel as ItemListPanel).update(manager.retrieve_selected_items_id())
		
func update_signals() -> void:
	for panel: Control in node_panels.get_children():
		if panel is UI_Panel and (panel is ItemListPanel):
			var __item_list: ItemListPanel = panel
			__item_list.trigger.connect(trigger.emit)

func _ready() -> void:
	update_signals()
	update_panels()
