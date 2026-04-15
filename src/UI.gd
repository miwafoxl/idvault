@abstract
extends Control
class_name UI

@warning_ignore("unused_signal")
signal trigger(tr: Trigger)

@abstract
func update() -> void

@abstract
func update_selection() -> void

@abstract
func request(__request: StringName, __param: Dictionary) -> void
