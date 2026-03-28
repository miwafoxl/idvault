extends Control
class_name UI

@export var manager: Manager
@export var action_manager: ActionManager
@export var node_panels: Control

func add_item() -> void:
	manager.append_items([Item.new(manager.unordered_items.size(), [
		Display.new("a".repeat(randi() % 10), "first test here".repeat(randi() % 2))
	])])
	action_manager.run(&"item.append.empty")
	update_panels.call_deferred()

func select_item(__id: int) -> void:
	pass

func query(__text: String) -> void:
	pass

func update_panels() -> void:
	for panel: Control in node_panels.get_children():
		if (panel is UI_Panel) and (panel is ItemListPanel):
			(panel as ItemListPanel).items_ref = manager.unordered_items
			(panel as ItemListPanel).update()
		
func update_signals() -> void:
	for panel: Control in node_panels.get_children():
		if panel is UI_Panel:
			if panel is ItemListPanel:
				(panel as ItemListPanel).add_item.connect(add_item)
				(panel as ItemListPanel).query.connect(query)

func _ready() -> void:
	action_manager.append_actions(action_manager.default)
	update_signals()
	update_panels()
