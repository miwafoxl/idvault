extends Resource
class_name Trigger

@export var type: TriggerTypes = TriggerTypes.TRIGGER
@export var relevant_id: StringName = ""
@export var parameters: Dictionary = {}

func _init(__type: TriggerTypes, __relevant_id: StringName = &"", \
		__param: Dictionary = {}) -> void:
	self.type = __type
	self.relevant_id = __relevant_id
	self.parameters = __param

enum TriggerTypes {
	TRIGGER,
	NONE,
	ACTION,
	DIALOG,
	MENU,
}
