extends Property
class_name Descriptor

@export var alias: String = "" # Required: Lowercase, no symbols or spaces
@export var priority: int = 0

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DESCRIPTOR"

func _init(__alias: String, __priority: int = 0) -> void:
	self.alias = __alias
	self.priority = __priority
	self.id = RandomString.new("P_").value
