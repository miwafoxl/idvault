extends Element
class_name RangedDate

# NULL values can be set as Unknown in UI
@export var type: RangedDateTypes = RangedDateTypes.DATE_RANGED
@export var start_date: Date = null;
@export var end_date: Date = null; # null = present day, present time

enum RangedDateTypes {
	DATE_RANGED,
	DATE_ALIVE,  # Ex: Birth and Death
	DATE_ACTIVITY,  # Ex: Active since x, artist disbanded in y
}

func is_range_inverted(__bound_1: Date, __bound_2: Date) -> bool:
	if __bound_2.yyyymmdd.z > __bound_1.yyyymmdd.z or \
			__bound_2.yyyymmdd.y > __bound_1.yyyymmdd.y or \
			__bound_2.yyyymmdd.x > __bound_2.yyyymmdd.x:
		return true
	return false

func new(__range: Array[Date]) -> RangedDate:
	var __bound_1: Date = __range[0];
	var __bound_2: Date = __range[1];
	var __invert_op: bool = is_range_inverted(__bound_1, __bound_2)
	if not __invert_op:
		self.start_date = __bound_1
		self.end_date = __bound_2
	else:
		self.start_date = __bound_2
		self.end_date = __bound_1
	return self
