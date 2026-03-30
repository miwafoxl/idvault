extends Node

@export var action_manager: ActionManager
@export var manager: Manager

## Creates a single empty item
func test1() -> bool:
	var __id: int = randi() % 100
	if not action_manager.run(&"item.append.items", __id):
		return false
	if not action_manager.run(&"item.remove.by_item_id", __id): #      CLEANUP
		return false
	return true

## Creates 10 empty items
func test2() -> bool:
	var __id: int = randi() % 100
	if not action_manager.run(&"item.append.items", __id, 10):
		return false
	if not action_manager.run.callv([&"item.remove.by_item_id"] + \
			range(__id, __id + 10)): #      CLEANUP
		return false
	return true

## Creates a single item and gives it a propriety afterwards
func test3() -> bool:
	var __id: int = randi() % 100
	var __item: Item = Item.new(__id, [
		Display.new("Momento")
	])
	__item.append_proprieties([
		Link.new([__item.id]),
		Descriptor.new("test")
	])
	if not manager.append_items([__item]):
		return false
	if not manager.remove_items([0]): #      CLEANUP
		return false
	return true

## Creates a single item, give it a propriety, then delete the propriety \
## without deleting the whole item
func test4() -> bool:
	var __id: int = randi() % 100
	var __item: Item = Item.new(__id)
	__item.append_proprieties([
		Link.new([__item.id])
	])
	if not manager.append_items([__item]):
		return false
	manager.unordered_items[0].remove_proprieties([0])
	if not manager.remove_items([0]): #      CLEANUP
		return false
	return true

## Create an item and retrieves it as if only ID was known
func test5() -> bool:
	var __id: int = randi() % 100
	var __item: Item = Item.new(__id)
	if not manager.append_items([__item]):
		return false
	var __get_item: Array[Item] = manager.get_item_by_id([__id])
	if __get_item.is_empty() or __get_item[0] == null:
		return false
	if not manager.remove_items([0]): #      CLEANUP
		return false
	return true

## Create an item with a parameter and validly links to itself with \
## a link parameter
func test6() -> bool:
	var __id: int = randi() % 100
	var __param: Parameter = Parameter.new(Parameter.ParameterTypes.NUMBER)
	var __item: Item = Item.new(__id, [
		Display.new("Fodendo"),
		__param
	])
	__item.append_proprieties([
		Link.new([__item.id], {__param.id: 7}),
		Descriptor.new("test")
	])
	if not manager.append_items([__item]):
		return false
	if not manager.remove_items([0]): #      CLEANUP
		return false
	return true

## Create an item with a parameter and validly links to itself with \
## a link parameter, then queries it.
func test7() -> bool:
	var __id: int = randi() % 100
	var __param: Parameter = Parameter.new(Parameter.ParameterTypes.NUMBER)
	var __item: Item = Item.new(__id, [
		Display.new("Fodendo"),
		__param
	])
	__item.append_proprieties([
		Link.new([__item.id], {__param.id: 7}),
		Descriptor.new("test")
	])
	if not manager.append_items([__item]):
		return false
	
	var __q: Query = Query.new("test", manager.unordered_items, \
			manager.descriptors_cx, manager.parameters_cx, manager.links_cx)
	if not __q.parse_raw():
		return false
	__q.compute()
	var __q_result: Array[Item] = await __q.done
	return true

func do_tests() -> Array[int]:
	var __failed_at: Array[int] = []
	if not test1(): __failed_at.append(1)
	if not test2(): __failed_at.append(2)
	#if not test3(): __failed_at.append(3)
	#if not test4(): __failed_at.append(4)
	#if not test5(): __failed_at.append(5)
	#if not test6(): __failed_at.append(6)
	#if not await test7(): __failed_at.append(7)
	return __failed_at
	
func _ready() -> void:
	action_manager.append_actions(action_manager.default, true)
	var __test_results: Array[int] = do_tests()
	if __test_results.is_empty():
		print("All tests passed")
	else:
		printerr("Test failed: ", __test_results)
	
