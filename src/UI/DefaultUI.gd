extends UI
class_name DefaultUI

@export var manager: ItemManager

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
	for __control: Control in %HBOX_C.get_children():
		if __control is not DefaultUI_Panel: continue
		if __control is DefaultUI_ItemListPanel:
			var __panel: DefaultUI_ItemListPanel = __control
			__panel.items_ref = manager.get_staged_items_pages(100, __panel.selected_page)
			__panel.total_pages = manager.get_staged_items_total_pages(100)
			__panel.update(manager.retrieve_selected_items_id())
		if __control is DefaultUI_ItemOverview:
			var __panel: DefaultUI_ItemOverview = __control
			__panel.items_ref = manager.selected_items
			__panel.items_network = manager.cache_retrieve_link_network(manager.selected_items)
			__panel.update()
		
func update_signals() -> void:
	for panel: Control in %HBOX_C.get_children():
		if panel is DefaultUI_Panel and (panel is DefaultUI_ItemListPanel):
			var __item_list: DefaultUI_ItemListPanel = panel
			__item_list.trigger.connect(trigger.emit)

func popup_menu(__id: StringName, __param: Dictionary = {}, \
		__position: Vector2i = DisplayServer.mouse_get_position()) -> void:
	var __menu: ContextMenu = %MENU_MANAGER.retrieve_menu(__id, __param)
	if __menu == null:
		printerr("No menu with id '%s'" % __id)
	#print_debug(__id, __param)
	add_child(__menu)
	__menu.action_query.connect(%MENU_MANAGER.menu_action_callback, \
			ConnectFlags.CONNECT_DEFERRED)
	__menu.set_position(__position)
	__menu.set_force_native(true)
	__menu.popup()

func request(__request: Dictionary, __param: Dictionary) -> void:
	match __request:
		&"item_properties", \
		&"message", \
		&"user_confirmation":
			%DIALOG_MANAGER.open(__request, __param)
		&"update_item_properties":
			%DIALOG_MANAGER.update_dialog(&"item_properties")
		_:
			printerr("DefaultUI: invalid request '%s'" % __request)
	
func _ready() -> void:
	%DIALOG_MANAGER.append_dialog(%DIALOG_MANAGER.default)
	%MENU_MANAGER.append_menus(%MENU_MANAGER.default)
	%DIALOG_MANAGER.trigger.connect(trigger.emit)
	%MENU_MANAGER.trigger.connect(trigger.emit)
	update_signals()
	update_panels()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	#print_debug(event as InputEventKey)
	if event.is_action("test_item"):
		trigger.emit(Trigger.new(
			Trigger.TriggerTypes.ACTION,
			&"items.append.testitem"
		))
