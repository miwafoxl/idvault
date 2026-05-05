extends Node
class_name Application

@export var default_ui: PackedScene
var ui: UI = null

func swap_ui(__ui: PackedScene) -> void:
	var __node: UI = __ui.instantiate()
	ui = __node
	ui.modules({
		"item": %ITEM_MODULE })
	ui.trigger.connect(process_trigger)
	%ITEM_MODULE.stage_updated.connect(ui.update, ConnectFlags.CONNECT_DEFERRED)
	%ITEM_MODULE.selection_updated.connect(ui.update_selection, ConnectFlags.CONNECT_DEFERRED)
	add_child(ui, true)

func ui_request(__request: StringName, __param: Dictionary) -> void:
	ui.request(__request, __param)

func process_trigger(__tr: Trigger) -> void:
	if (__tr == null) or (__tr.relevant_id.is_empty()):
		printerr("Received invalid or null trigger")
		return
	match __tr.type:
		Trigger.TriggerTypes.ACTION:
			%ACTION_MODULE.run(__tr.relevant_id, __tr.parameters)
		Trigger.TriggerTypes.UI_REQUEST:
			ui_request(__tr.relevant_id, __tr.parameters)
		_:
			printerr("Invalid trigger type '%s'" % \
				Trigger.TriggerTypes.keys()[__tr.type])

func _ready() -> void:
	%ACTION_MODULE.append_actions(%ACTION_MODULE.default, true)
	%ACTION_MODULE.trigger.connect(process_trigger)
	%ITEM_MODULE.trigger.connect(process_trigger)
	swap_ui(default_ui)
	var __disable_test: bool = true
	var __test_results: Array = [] if __disable_test else testing.do_tests()
	if __test_results.is_empty():
		print(["All tests passed", "Tests disabled"][__disable_test as int])
	else:
		printerr("Test failed: ", __test_results)
