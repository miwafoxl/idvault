extends Control
class_name UI

@export var manager: Manager
@export var action_manager: ActionManager
@export var node_panels: Control

func give_managers(__managers: Dictionary) -> void:
	for __key: String in __managers:
		match __key:
			"item":
				manager = __managers[__key]
			"action":
				action_manager = __managers[__key]
			_:
				printerr("UI: unknown manager '%s' provided to UI" % __key)

func add_item() -> void:
	action_manager.run(&"items.append.testitem", {})
	action_manager.run(&"items.stage.alphabetical", {
		"item": manager.unordered_items })
	update_panels.call_deferred()

func select_item(__id: int) -> void:
	action_manager.run(&"items.select.by_item_id", {
		"item_id": [__id] })
	update_panels.call_deferred()

func select_item_append(__id: int) -> void:
	action_manager.run(&"items.select.by_item_id_append", {
		"item_id": [__id] })
	update_panels.call_deferred()

func deselect_item(__id: int) -> void:
	action_manager.run(&"items.deselect.by_item_id", {
		"item_id": [__id] })
	update_panels.call_deferred()

func deselect_all() -> void:
	action_manager.run(&"items.deselect.all", {})
	update_panels.call_deferred()

func query(__text: String) -> void:
	action_manager.run(&"items.query.text", {})
	update_panels.call_deferred()

func update_panels() -> void:
	for panel: Control in node_panels.get_children():
		if (panel is UI_Panel) and (panel is ItemListPanel):
			(panel as ItemListPanel).items_ref = manager.get_staged_items_pages()
			(panel as ItemListPanel).update(manager.retrieve_selected_items_id())
		
func update_signals() -> void:
	for panel: Control in node_panels.get_children():
		if panel is UI_Panel and (panel is ItemListPanel):
			var __item_list: ItemListPanel = panel
			__item_list.add_item.connect(add_item)
			__item_list.select_item.connect(select_item)
			__item_list.select_item_append.connect(select_item_append)
			__item_list.deselect_item.connect(deselect_item)
			__item_list.deselect_all.connect(deselect_all)
			__item_list.query.connect(query)

func _ready() -> void:
	update_signals()
	update_panels()
