extends Window
class_name Dialog

@export var args: Dictionary = {}
@export var returns: bool = false
var return_id: String = ""

@warning_ignore("unused_signal")
signal returning(__id: String, return_args: Array)

func pop() -> void:
	self.visible = true
	self.popup_centered()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			self.queue_free()
			
func _ready() -> void:
	self.visible = false
	self.set_force_native(true)
