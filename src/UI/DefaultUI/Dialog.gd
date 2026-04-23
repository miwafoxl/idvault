@abstract
extends Window
class_name DefaultUI_Dialog

@export var args: Dictionary = {}
@export var important: bool = false
var alias: StringName

@warning_ignore_start("unused_signal")
signal trigger(tr: Trigger)
signal handle_close_request(StringName)
@warning_ignore_restore("unused_signal")
#region OVERRIDES

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			close_request()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	if event.is_action_pressed("enter"):
		enter_request()
	if event.is_action_pressed("exit"):
		close_request()
			
func _ready() -> void:
	self.visible = false
	self.set_force_native(true)

func _update_arguments() -> void:
	pass

func close_request() -> void:
	handle_close_request.emit(alias)

#endregion OVERRIDES
#region ABSTRACT FUNCTIONS

@abstract
func enter_request() -> void

#endregion

func pop() -> void:
	self.visible = true
	self.set_exclusive(important)
	self.popup_centered()
