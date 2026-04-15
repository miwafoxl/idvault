extends DefaultUI_Widget
class_name ItemDisplayWidget

@export var related_stage_id: int = 0
@export var related_id: String = ""
@export var title: String = "";
@export var subtitle: String = "";
var display_selected: bool = false

@export var node_title: Label 
@export var node_subtitle: Label

#region OVERRIDES

func update() -> void:
	node_title.set_text(self.title)
	node_subtitle.set_text(self.subtitle)
	update_color()

#endregion
#region INPUT

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if not event.is_pressed(): return
	var __mouse_act: InputEventMouseButton = event 
	match __mouse_act.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			if __mouse_act.double_click:
				trigger.emit(Trigger.new(
				Trigger.TriggerTypes.ACTION,
				&"items.dialog.selected_item_properties"
			))
			if KeyboardModifiers.is_shift_modifier:
				trigger.emit(Trigger.new(
					Trigger.TriggerTypes.ACTION,
					&"items.select.by_item_id_toggle", 
					{"item_id": [related_id]}
				))
			else:
				trigger.emit(Trigger.new(
					Trigger.TriggerTypes.ACTION,
					&"items.select.by_item_id", 
					{"item_id": [related_id]}
				))
			update_selected_state()
		MouseButton.MOUSE_BUTTON_RIGHT:
			trigger.emit(Trigger.new(
				Trigger.TriggerTypes.ACTION,
				&"items.select.by_item_id", {
					"item_id": [related_id],
					"only_if_nothing_selected": true}
			))
			trigger.emit(Trigger.new(
				Trigger.TriggerTypes.MENU,
				&"panel.itemlist.item_menu"
			))
			update_selected_state()

#endregion
#region FEEDBACK

func update_selected_state() -> void:
	if not display_selected:
		self.display_selected = true
	else:
		self.display_selected = false

func update_color() -> void:
	if display_selected:
		self.set_modulate(Color(0.537, 0.537, 1.0, 1.0))
	else:
		self.set_modulate(Color.WHITE)

#endregion FEEDBACK
