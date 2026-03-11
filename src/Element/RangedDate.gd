extends Element
class_name RangedDate

# NULL values can be set as Unknown in UI
@export var start_date: Date = null;
@export var end_date: Date = null;

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
