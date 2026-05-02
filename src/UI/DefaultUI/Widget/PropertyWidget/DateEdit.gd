extends PropertyWidget
class_name DateEditWidget

const DAYS_IN_MONTHS: Array[int] = [ 31,29,31,30,31,30,31,31,30,31,30,31 ]

@export var description: LineEdit
@export var day: LineEdit
@export var month: OptionButton
@export var year: LineEdit

func deserialize(__property: Property) -> void:
	var __prop: Date = __property
	related_prop_id = __prop.id
	description.text = __prop.description
	day.text = str(__prop.yyyymmdd.z)
	year.text = str(__prop.yyyymmdd.x)
	month.select(__prop.yyyymmdd.y - 1)
	month.set_meta(UNCHANGED_META_STR, month.selected)
	for __control: Control in [description, day, year]:
		__control.set_meta(UNCHANGED_META_STR, __control.text)

func check_if_changed() -> bool:
	var __changed: int = 0
	for __control: Control in [description, day, year]:
		__changed += int(__control.get_meta(UNCHANGED_META_STR) != __control.text)
	__changed += int(month.get_meta(UNCHANGED_META_STR) != month.selected)
	return __changed > 0

# TODO: Make configurable when the user puts a number higher than the month currently
# set, either modulate to current month (%) or max out 
func get_as_property() -> Property:
	var __get_yyyymmdd: Callable = func(__day: int, __year: int, __month_selected: int) -> Vector3i:
		var __yyyymmdd: Vector3i = Vector3i.ZERO
		__yyyymmdd.x = __year
		__yyyymmdd.z = ((__day - 1) % DAYS_IN_MONTHS[__month_selected] + 1) \
				if __day == 0 or __day > DAYS_IN_MONTHS[__month_selected] \
				else __day
		__yyyymmdd.y = __month_selected + 1
		return __yyyymmdd
	var __description: String = description.text.strip_edges().strip_escapes()
	var __new_yyyymmdd: Vector3i = __get_yyyymmdd.call(
		abs(day.text.strip_edges().strip_escapes().to_int()),
		abs(year.text.strip_edges().strip_escapes().to_int()),
		month.selected
	)
	return Date.new(__new_yyyymmdd, __description)
