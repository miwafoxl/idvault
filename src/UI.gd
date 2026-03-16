extends Control
class_name UI

@export var manager: Manager
@export var node_panels: Control

func add_entry() -> void:
	manager.append_entries([Entry.new(manager.unordered_entries.size(), [
		Display.new("a".repeat(randi() % 10), "first test here".repeat(randi() % 2))
	])])
	update_panels.call_deferred()

func select_entry(__id: int) -> void:
	pass

func query(__text: String) -> void:
	pass

func update_panels() -> void:
	for panel: Control in node_panels.get_children():
		if (panel is UI_Panel) and (panel is PanelEntryList):
			(panel as PanelEntryList).items_ref = manager.unordered_entries
			(panel as PanelEntryList).update()
		
func update_signals() -> void:
	for panel: Control in node_panels.get_children():
		if panel is UI_Panel:
			if panel is PanelEntryList:
				(panel as PanelEntryList).add_entry.connect(add_entry)
				(panel as PanelEntryList).query.connect(query)

func _ready() -> void:
	update_signals()
	update_panels()
