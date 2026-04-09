extends Dialog
class_name MessageDialog

const MIN_LABEL_SIZE: int = 70

@export var message_node: RichTextLabel
@export var confirm_node: Button

#region OVERRIDES

func enter_request() -> void:
	close_request()

func close_request() -> void:
	self.queue_free()

#endregion OVERRIDES
#region INPUT

func _on_about_to_popup() -> void:
	message_node.text = args.get("message")
	var __size_y: int = ceil(message_node.get_size().y)
	if __size_y > MIN_LABEL_SIZE:
		var __new_y: int = __size_y - MIN_LABEL_SIZE
		self.set_size(Vector2i(self.size.x, self.size.y + __new_y))

func _on_button_ok_button_up() -> void:
	close_request()

#endregion INPUT
