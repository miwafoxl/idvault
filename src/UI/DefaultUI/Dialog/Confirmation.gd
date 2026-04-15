extends DefaultUI_Dialog
class_name DefaultUI_UserConfirmationDialog

const MIN_LABEL_SIZE: int = 70

@export var message_node: RichTextLabel

#region OVERRIDES

func enter_request() -> void:
	var __callback: Callable = args.get("callback")
	__callback.call()
	close_request()

func close_request() -> void:
	self.queue_free()

#endregion
#region INPUT

func _on_about_to_popup() -> void:
	message_node.text = args.get("message")
	var __size_y: int = ceil(message_node.get_size().y)
	if __size_y > MIN_LABEL_SIZE:
		var __new_y: int = __size_y - MIN_LABEL_SIZE
		self.set_size(Vector2i(self.size.x, self.size.y + __new_y))

func _on_button_cancel() -> void:
	close_request()

func _on_button_confirm() -> void:
	enter_request()

#endregion INPUT
