extends Node

@export var manager: Manager


## Creates and removes a single entry
func test1() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id)
	if not manager.append_entries([__entry]):
		return false
	if not manager.remove_entries([0]):
		return false
	return true

## Creates 10 entries and removes all of them
func test2() -> bool:
	var __entries: Array[Entry] = []
	var __id: int = randi() % 100
	for i: int in range(10):
		var __entry: Entry = Entry.new(__id + i)
		__entries.append(__entry)
	if not manager.append_entries(__entries):
		return false
	if not manager.remove_entries([0,1,2,3,4,5,6,7,8,9]):
		return false
	return true

## Creates a single entry, give it a element then delete the entry
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
	if not manager.remove_entries([0]):
		return false
	return true

## Creates a single entry, give it a element, delete the element then the entry
func test4() -> bool:
	var __id: int = randi() % 100
	var __entry: Entry = Entry.new(__id)
	__entry.append_elements([
		Link.new([__entry.id])
	])
	if not manager.append_entries([__entry]):
		return false
	manager.unordered_entries[0].remove_elements([0])
	if not manager.remove_entries([0]):
		return false
	return true

func _ready() -> void:
	
	if not test1():
		printerr("Test1 failed")
	if not test2():
		printerr("Test2 failed")
	if not test3():
		printerr("Test3 failed")
	if not test4():
		printerr("Test4 failed")
