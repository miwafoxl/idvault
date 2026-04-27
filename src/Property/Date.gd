extends Property
class_name Date

@export var description: String = ""
@export var yyyymmdd: Vector3i = Vector3i.ZERO;
@export var utc: int = 0;

# Get seconds since
func get_difference(__yyyymmdd: Vector3i) -> int:
	var __timestamp_1: int = Time.get_unix_time_from_datetime_dict({
		"year": yyyymmdd[0],
		"month": yyyymmdd[1],
		"day": yyyymmdd[2],
	})
	var __timestamp_2: int = Time.get_unix_time_from_datetime_dict({
		"year": __yyyymmdd[0],
		"month": __yyyymmdd[1],
		"day": __yyyymmdd[2],
	})
	return abs(__timestamp_2 - __timestamp_1)

func get_type_as_string() -> StringName:
	return &"PROPERTY.TYPES.DATE"

func _init(__yyyymmdd: Vector3i, __description: String = "", __utc: int = 0) -> void:
	self.yyyymmdd = __yyyymmdd
	self.utc = __utc
	self.description = __description
	self.id = RandomString.new("P_").value
