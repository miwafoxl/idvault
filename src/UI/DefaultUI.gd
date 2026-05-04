extends UI
class_name DefaultUI

@export var mod_item: ItemModule

func update() -> void:
	update_panels()

func update_selection() -> void:
	update_panels()

func modules(__modules: Dictionary) -> void:
	for __key: String in __modules:
		match __key:
			"item":
				mod_item = __modules[__key]
			_:
				printerr("UI: unknown module '%s' provided to UI" % __key)

func update_panels() -> void:
	for __control: Control in %HBOX_C.get_children():
		if __control is not DefaultUI_Panel: continue
		if __control is DefaultUI_ItemListPanel:
			var __panel: DefaultUI_ItemListPanel = __control
			__panel.items_ref = mod_item.get_staged_items_pages(100, __panel.selected_page)
			__panel.total_pages = mod_item.get_staged_items_total_pages(100)
			__panel.update(mod_item.retrieve_selected_items_id())
		if __control is DefaultUI_ItemOverview:
			var __panel: DefaultUI_ItemOverview = __control
			__panel.items_ref = mod_item.selected_items
			__panel.items_network = mod_item.cache_retrieve_link_network(mod_item.selected_items)
			__panel.update()
		
func update_signals() -> void:
	for panel: Control in %HBOX_C.get_children():
		if panel is DefaultUI_Panel and (panel is DefaultUI_ItemListPanel):
			var __item_list: DefaultUI_ItemListPanel = panel
			__item_list.trigger.connect(trigger.emit)

func popup_menu(__id: StringName, __param: Dictionary = {}, \
		__position: Vector2i = DisplayServer.mouse_get_position()) -> void:
	var __menu: ContextMenu = %MENU_MODULE.retrieve_menu(__id, __param)
	if __menu == null:
		printerr("No menu with id '%s'" % __id)
	#print_debug(__id, __param)
	add_child(__menu)
	__menu.action_query.connect(%MENU_MODULE.menu_action_callback, \
			ConnectFlags.CONNECT_DEFERRED)
	__menu.set_position(__position)
	__menu.set_force_native(true)
	__menu.popup()

func request(__request: StringName, __param: Dictionary) -> void:
	var is_menu: bool = __request.begins_with("menu:")
	var is_dialog: bool = __request.begins_with("dialog:")
	
	if is_menu:
		popup_menu(__request.get_slice("menu:", 1), __param)
	elif is_dialog:
		%DIALOG_MODULE.open(__request.get_slice("dialog:", 1), __param)
	else:
		printerr("DefaultUI: invalid request '%s'" % __request)
	
func _ready() -> void:
	%DIALOG_MODULE.append_dialog(%DIALOG_MODULE.default)
	%MENU_MODULE.append_menus(%MENU_MODULE.default)
	%DIALOG_MODULE.trigger.connect(trigger.emit)
	%MENU_MODULE.trigger.connect(trigger.emit)
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
