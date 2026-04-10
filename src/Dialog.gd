@abstract
extends Window
class_name Dialog

@export var args: Dictionary = {}
@export var important: bool = false

signal trigger(tr: Trigger)

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

#endregion OVERRIDES
#region ABSTRACT FUNCTIONS

@abstract
func enter_request() -> void

@abstract
func close_request() -> void

#endregion

func pop() -> void:
	self.visible = true
	self.set_exclusive(important)
	self.popup_centered()
