extends Node
class_name Application

@export var default_ui: PackedScene
@export var item_manager: Manager
@export var action_manager: ActionManager
@export var dialog_manager: DialogManager
@export var menu_manager: MenuManager

@onready var testing = $Testing
var ui: Control = null

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	if not ui == null:
		if ui.is_connected(&"request_menu", popup_menu):
			ui.disconnect(&"request_menu", popup_menu)
		ui.free()
	ui = __node
	ui.give_managers({
		"item": item_manager,
		"action": action_manager })
	ui.request_menu.connect(popup_menu)
	add_child(__node, true)

func popup_menu(__id: StringName, __param: Dictionary = {}, \
		__position: Vector2i = DisplayServer.mouse_get_position()) -> void:
	var __menu: PopupMenu = menu_manager.retrieve_menu(__id)
	if __menu == null:
		printerr("No menu with id '%s'" % __id)
	add_child(__menu)
	__menu.set_position(__position)
	__menu.set_force_native(true)
	__menu.popup()

func _ready() -> void:
	action_manager.append_actions(action_manager.default, false)
	dialog_manager.append_dialog(dialog_manager.default, false)
	menu_manager.append_menus(menu_manager.default, true)
	swap_ui(default_ui)
	var __test_results: Array[int] = testing.do_tests()
	if __test_results.is_empty():
		print("All tests passed")
	else:
		printerr("Test failed: ", __test_results)
