extends Property
class_name RangedDate

@export var description: String = ""
@export var start_date: Vector3i = Vector3i.ZERO;
@export var end_date: Vector3i = Vector3i.ZERO;
@export var indefinite_end: bool = false

func should_swap(__bound_1: Vector3i, __bound_2: Vector3i) -> bool:
	if __bound_1 < __bound_2 or __bound_2 == Vector3i.ZERO:
		return false
	return true

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.RANGED_DATE"

func _init(__range: Array[Vector3i], __indefinite: bool = false) -> void:
	var __bound_1: Vector3i = __range[0];
	var __bound_2: Vector3i = __range[1];
	self.indefinite_end = __indefinite
	self.start_date = __bound_1
	self.end_date = __bound_2
	if should_swap(__bound_1, __bound_2) and not __indefinite:
		self.start_date = __bound_2
		self.end_date = __bound_1
	self.id = RandomString.new("P_").value
