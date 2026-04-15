extends Node
class_name Application

@export var default_ui: PackedScene
@export var item_manager: ItemManager
@export var action_manager: ActionManager
@export var menu_manager: MenuManager

@onready var testing = $Testing
var ui: UI = null

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	if not ui == null:
		if ui.is_connected(&"request_menu", popup_menu):
			ui.disconnect(&"request_menu", popup_menu)
		ui.free()
	ui = __node
	ui.give_managers({
		"item": item_manager })
	ui.request_menu.connect(popup_menu)
	ui.trigger.connect(process_trigger)
	item_manager.stage_updated.connect(ui.update, ConnectFlags.CONNECT_DEFERRED)
	item_manager.selection_updated.connect(ui.update_selection, ConnectFlags.CONNECT_DEFERRED)
	add_child(ui, true)

func ui_request(__id: StringName, __param: Dictionary) -> void:
	ui.request(__id, __param)

func popup_menu(__id: StringName, __param: Dictionary = {}, \
		__position: Vector2i = DisplayServer.mouse_get_position()) -> void:
	var __menu: ContextMenu = menu_manager.retrieve_menu(__id, __param)
	if __menu == null:
		printerr("No menu with id '%s'" % __id)
	#print_debug(__id, __param)
	add_child(__menu)
	__menu.action_query.connect(menu_manager.menu_action_callback, \
			ConnectFlags.CONNECT_DEFERRED)
	__menu.set_position(__position)
	__menu.set_force_native(true)
	__menu.popup()

func process_trigger(__tr: Trigger) -> void:
	if (__tr == null) or (__tr.relevant_id.is_empty()):
		printerr("Received invalid or null trigger")
		return
	match __tr.type:
		Trigger.TriggerTypes.ACTION:
			action_manager.run(__tr.relevant_id, __tr.parameters)
		Trigger.TriggerTypes.MENU:
			popup_menu(__tr.relevant_id, __tr.parameters)
		Trigger.TriggerTypes.UI_REQUEST:
			ui_request(__tr.relevant_id, __tr.parameters)
		_:
			printerr("Invalid trigger type '%s'" % \
				Trigger.TriggerTypes.keys()[__tr.type])

func _ready() -> void:
	action_manager.append_actions(action_manager.default, true)
	menu_manager.append_menus(menu_manager.default, false)
	action_manager.trigger.connect(process_trigger)
	menu_manager.trigger.connect(process_trigger)
	item_manager.trigger.connect(process_trigger)
	swap_ui(default_ui)
	var __disable_test: bool = true
	var __test_results: Array = [] if __disable_test else testing.do_tests()
	if __test_results.is_empty():
		print(["All tests passed", "Tests disabled"][__disable_test as int])
	else:
		printerr("Test failed: ", __test_results)
