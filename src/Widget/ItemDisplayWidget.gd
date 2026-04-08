extends Widget
class_name ItemDisplayWidget

@export var related_stage_id: int = 0
@export var related_id: String = ""
@export var title: String = "";
@export var subtitle: String = "";
var display_selected: bool = false

@export var node_title: Label 
@export var node_subtitle: Label

@warning_ignore("unused_signal")
signal select_append()
signal select()
signal request_menu(__menu_id: StringName)

func update() -> void:
	node_title.set_text(self.title)
	node_subtitle.set_text(self.subtitle)
	update_color()

func update_color() -> void:
	if display_selected:
		self.set_modulate(Color(0.537, 0.537, 1.0, 1.0))
	else:
		self.set_modulate(Color.WHITE)

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	var __mouse_act: InputEventMouseButton = event 
	match __mouse_act.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			select.emit(related_id)
			if not display_selected:
				self.display_selected = true
			else:
				self.display_selected = false
		MouseButton.MOUSE_BUTTON_RIGHT:
			#select.emit(related_id)
			if not display_selected:
				self.display_selected = true
			else:
				self.display_selected = false
			request_menu.emit.call_deferred(&"panel.itemlist.item_menu")
