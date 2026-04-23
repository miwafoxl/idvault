extends UI
class_name DefaultUI

@export var manager: ItemManager
@export var dialog_manager: DefaultUI_DialogManager
@export var node_panels: Control

@warning_ignore("unused_signal")
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
		if (panel is DefaultUI_Panel) and (panel is DefaultUI_ItemListPanel):
			(panel as DefaultUI_ItemListPanel).items_ref = manager.get_staged_items_pages()
			(panel as DefaultUI_ItemListPanel).update(manager.retrieve_selected_items_id())
		
func update_signals() -> void:
	for panel: Control in node_panels.get_children():
		if panel is DefaultUI_Panel and (panel is DefaultUI_ItemListPanel):
			var __item_list: DefaultUI_ItemListPanel = panel
			__item_list.trigger.connect(trigger.emit)

func request(__request: StringName, __param: Dictionary) -> void:
	match __request:
		&"item_properties", \
		&"message", \
		&"user_confirmation":
			dialog_manager.open(__request, __param)
		&"update_item_properties":
			dialog_manager.update_dialog(&"item_properties")
		_:
			printerr("DefaultUI: invalid request '%s'" % __request)
	
func _ready() -> void:
	dialog_manager.append_dialog(dialog_manager.default)
	dialog_manager.trigger.connect(trigger.emit)
	update_signals()
	update_panels()
