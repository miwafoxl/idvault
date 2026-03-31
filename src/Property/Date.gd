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

func _init(__year: int, __month: int, __day: int = 0,\
		__description: String = "", __utc: int = 0) -> void:
	self.yyyymmdd = Vector3i(__year, __month, __day)
	self.utc = __utc
	self.description = __description
	self.flush_id()
