extends Property
class_name Parameter

@export var param_id: String = "";
@export var order: int = 0;
@export var type: ParameterTypes = ParameterTypes.PARAMETER;

enum ParameterTypes {
	PARAMETER,
	STRING,
	NUMBER,
}

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.PARAMETER"

func _init(__type: ParameterTypes = ParameterTypes.NUMBER, __order: int = 0, \
		__id: String = RandomString.new("p_").value):
	self.param_id = __id
	self.order = __order
	self.type = __type
	self.id = RandomString.new("P_").value
