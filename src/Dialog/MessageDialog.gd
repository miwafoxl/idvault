extends Dialog
class_name MessageDialog

const MIN_LABEL_SIZE: int = 70

@export var message_node: RichTextLabel
@export var confirm_node: Button

func _on_about_to_popup() -> void:
	message_node.text = args.get("message")
	var __size_y: int = ceil(message_node.get_size().y)
	if __size_y > MIN_LABEL_SIZE:
		var __new_y: int = __size_y - MIN_LABEL_SIZE
		self.set_size(Vector2i(self.size.x, self.size.y + __new_y))

func _on_button_ok_button_up() -> void:
	self.queue_free()
