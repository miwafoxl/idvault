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
	month.select(__prop.yyyymmdd.y - 1)
	year.text = str(__prop.yyyymmdd.x)
	month.set_meta(UNCHANGED_META_STR, month.selected)
	for __lineedit: Control in [description, day, year]:
		__lineedit.set_meta(UNCHANGED_META_STR, __lineedit.text)

func check_if_changed() -> bool:
	var __changed: bool = false
	for __lineedit: Control in [description, day, year]:
		if not __lineedit.get_meta(UNCHANGED_META_STR) == __lineedit.text:
			__changed = true
	if not month.get_meta(UNCHANGED_META_STR) == month.selected:
		__changed = true
	return __changed

# TODO: Make configurable when the user puts a number higher than the month currently
# set, either modulate to current month (%) or max out 
func get_as_property() -> Property:
	var __description: String = description.text.strip_edges().strip_escapes()
	var __year: int = abs(year.text.strip_edges().strip_escapes().to_int())
	var __day: int = abs(day.text.strip_edges().strip_escapes().to_int())
	var __new_yyyymmdd: Vector3i = Vector3i.ZERO
	__new_yyyymmdd.x = 1999 if __year == 0 else __year
	__new_yyyymmdd.z = ((__day - 1) % DAYS_IN_MONTHS[month.selected] + 1) \
			if __day == 0 or __day > DAYS_IN_MONTHS[month.selected] \
			else __day
	__new_yyyymmdd.y = month.selected + 1
	return Date.new(__new_yyyymmdd, __description)

func collect() -> Dictionary:
	var __collected: Dictionary = {}
	if marked_for_deletion:
		__collected = {"rem": {
			related_prop_id: marked_for_deletion
		}}
	elif check_if_changed():
		__collected = {"mod": {
			related_prop_id: get_as_property().deserialized(false)
		}}
	return __collected
