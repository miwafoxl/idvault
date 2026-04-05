extends Node
class_name Application

@export var default_ui: PackedScene
@export var item_manager: Manager
@export var action_manager: ActionManager
@export var dialog_manager: DialogManager

@onready var testing = $Testing
var ui: Control = null

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	if not ui == null:
		ui.free()
	ui = __node
	ui.give_managers({
		"item": item_manager,
		"action": action_manager
	})
	add_child(__node, true)

func _ready() -> void:
	action_manager.append_actions(action_manager.default, true)
	dialog_manager.append_dialog(dialog_manager.default, false)
	swap_ui(default_ui)
	var __test_results: Array[int] = testing.do_tests()
	if __test_results.is_empty():
		print("All tests passed")
	else:
		printerr("Test failed: ", __test_results)
