extends Node

@export var manager: Manager


## Creates a single entry
func test1() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id)
	if not manager.append_entries([__entry]):
		return false
	if not manager.remove_entries([0]): #      CLEANUP
		return false
	return true

## Creates 10 entries
func test2() -> bool:
	var __entries: Array[Entry] = []
	var __id: int = randi() % 100
	for i: int in range(10):
		var __entry: Entry = Entry.new(__id + i)
		__entries.append(__entry)
	if not manager.append_entries(__entries):
		return false
	if not manager.remove_entries([0,1,2,3,4,5,6,7,8,9]): #      CLEANUP
		return false
	return true

## Creates a single entry and gives it a element afterwards
func test3() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id, [
		Title.new("Momento")
	])
	__entry.append_elements([
		Link.new([__entry.id]),
		Descriptor.new("test")
	])
	if not manager.append_entries([__entry]):
		return false
	if not manager.remove_entries([0]): #      CLEANUP
		return false
	return true

## Creates a single entry, give it a element, then delete the element \
## without deleting the whole entry
func test4() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id)
	__entry.append_elements([
		Link.new([__entry.id])
	])
	if not manager.append_entries([__entry]):
		return false
	manager.unordered_entries[0].remove_elements([0])
	if not manager.remove_entries([0]): #      CLEANUP
		return false
	return true

## Create an entry and retrieves it as if only ID was known
func test5() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id)
	if not manager.append_entries([__entry]):
		return false
	var __get_entry: Array[Entry] = manager.get_entry_by_id([__id])
	if __get_entry.is_empty() or __get_entry[0] == null:
		return false
	if not manager.remove_entries([0]): #      CLEANUP
		return false
	return true

## Create an entry with a parameter and validly links to itself with \
## a link parameter
func test6() -> bool:
	var __id: int = randi() % 100
	var __param: Parameter = Parameter.new(Parameter.ParameterTypes.NUMBER)
	var __entry: Entry = Entry.new(__id, [
		Title.new("Fodendo"),
		__param
	])
	__entry.append_elements([
		Link.new([__entry.id], {__param.id: 7}),
		Descriptor.new("test")
	])
	if not manager.append_entries([__entry]):
		return false
	if not manager.remove_entries([0]): #      CLEANUP
		return false
	return true


func do_tests() -> Array[int]:
	var __failed_at: Array[int] = []
	if not test1(): __failed_at.append(1)
	if not test2(): __failed_at.append(2)
	if not test3(): __failed_at.append(3)
	if not test4(): __failed_at.append(4)
	if not test5(): __failed_at.append(5)
	if not test6(): __failed_at.append(6)
	return __failed_at
	
func _ready() -> void:
	var __test_results: Array[int] = do_tests()
	if __test_results.is_empty():
		print("All tests passed")
	else:
		printerr("Test failed: ", __test_results)
