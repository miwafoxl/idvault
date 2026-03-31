extends Widget
class_name ItemDisplayWidget

@export var related_id: int = 0
@export var title: String = "";
@export var subtitle: String = "";
var display_selected: bool = false
var mouse_on_top: bool = false

@export var node_title: Label 
@export var node_subtitle: Label

signal click()
signal hover()

func update() -> void:
	node_title.set_text(self.title)
	node_subtitle.set_text(self.subtitle)
	update_color()

func update_color() -> void:
	if mouse_on_top:
		if display_selected:
			self.set_modulate(Color(0.0, 1.0, 0.0, 1.0))
		else:
			self.set_modulate(Color(1.0, 0.0, 1.0, 1.0))
	if not mouse_on_top:
		if display_selected:
			self.set_modulate(Color(0.0, 0.0, 1.0, 1.0))
		else:
			self.set_modulate(Color.WHITE)

#region Theming

func _on_mouse_entered() -> void:
	if not mouse_on_top:
		mouse_on_top = true
		update_color()

func _on_mouse_exited() -> void:
	if mouse_on_top:
		mouse_on_top = false
		update_color()

func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	var __mouse_act: InputEventMouseButton = event 
	match __mouse_act.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed and not display_selected:
				click.emit(related_id)
				self.display_selected = true

#endregion
