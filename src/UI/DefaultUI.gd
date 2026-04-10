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

func add_item() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.append.testitem", {} ))
	
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.stage.alphabetical", {
			"item": manager.unordered_items
		} ))

func select_item(__item_id: String) -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.select.by_item_id", {
			"item_id": [__item_id]
		} ))

func select_item_append(__item_id: String) -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.select.by_item_id_append", {
			"item_id": [__item_id]
		} ))

func deselect_item(__item_id: String) -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.deselect.by_item_id", {
			"item_id": [__item_id]
		} ))

func deselect_all() -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.deselect.all", {} ))

func query(__text: String) -> void:
	trigger.emit(Trigger.new(
		Trigger.TriggerTypes.ACTION,
		&"items.query.text", {} ))

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
			__item_list.request_menu.connect(request_menu.emit)
			__item_list.deselect_item.connect(deselect_item)
			__item_list.deselect_all.connect(deselect_all)
			__item_list.query.connect(query)

func _ready() -> void:
	update_signals()
	update_panels()
