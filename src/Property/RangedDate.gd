extends Property
class_name RangedDate

@export var description: String = ""
@export var start_date: Vector3i = Vector3i.ZERO;
@export var end_date: Vector3i = Vector3i.ZERO;
@export var indefinite_end: bool = false

func is_range_inverted(__bound_1: Date, __bound_2: Date) -> bool:
	if __bound_2.yyyymmdd.z > __bound_1.yyyymmdd.z or \
			__bound_2.yyyymmdd.y > __bound_1.yyyymmdd.y or \
			__bound_2.yyyymmdd.x > __bound_2.yyyymmdd.x:
		return true
	return false

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.RANGED_DATE"

func _init(__range: Array[Date], __description: String = "") -> void:
	var __bound_1: Date = __range[0];
	var __bound_2: Date = __range[1];
	var __invert_op: bool = is_range_inverted(__bound_1, __bound_2)
	self.description = __description
	if not __invert_op:
		self.start_date = __bound_1
		self.end_date = __bound_2
	else:
		self.start_date = __bound_2
		self.end_date = __bound_1
	self.id = RandomString.new("P_").value
