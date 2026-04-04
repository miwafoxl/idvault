extends Dialog
class_name TestReturnDialog

@export var test_lineedit: LineEdit

func _on_button_ok_button_up() -> void:
	returning.emit(self.return_id, [test_lineedit.get_text()])
	self.queue_free()
