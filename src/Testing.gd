# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# Testing.gd
# ---------------------------------------------------------------
# Copyright (C) 2026   Amanda Severo   Contact: miwafoxl@proton.me
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see https://www.gnu.org/licenses/.

extends Node

#@export var dialog_manager: DefaultUI_DialogManager
@export var mod_item: ItemModule
@export var mod_action: ActionModule

## Creates a single empty item
func test1() -> bool:
	# Setup: --------------------------------------------------
	if not mod_action.run(&"items.append.items", {}):
		return false
	if not mod_action.run(&"items.stage.unordered", {
		"item": mod_item.unordered_items }):
			return false
	# Cleanup: ------------------------------------------------
	if not mod_action.run(&"items.select.by_item_index", {
		"item_idx": [0] }):
			return false
	if not mod_action.run(&"items.remove.selected", {}):
			return false
	return true

## Creates 10 empty items
func test2() -> bool:
	# Setup: --------------------------------------------------
	if not mod_action.run(&"items.append.items", {
		"count": 10 }):
			return false
	if not mod_action.run(&"items.stage.unordered", {
		"item": mod_item.unordered_items }):
			return false
	# Cleanup: ------------------------------------------------
	if not mod_action.run(&"items.select.by_item_index", {
		"item_idx": range(10) }):
			return false
	if not mod_action.run(&"items.remove.selected", {}):
		return false
	return true

## Creates a single item and gives it a property afterwards
func test3() -> bool:
	# Setup: --------------------------------------------------
	if not mod_action.run(&"items.append.items", {
		"properties": [Display.new("Momento")] }):
			return false
	if not mod_action.run(&"items.stage.unordered", {
		"item": mod_item.unordered_items }):
			return false
	if not mod_action.run(&"items.select.by_item_index", {
		"item_idx": [0] }):
			return false
	var __selected_id: String = mod_item.selected_items[0].id
	if not mod_action.run(&"items.append.properties_to_selected", {
		"properties": [Link.new(__selected_id), 
					   Descriptor.new("test")] }):
			return false
	# Cleanup: ------------------------------------------------
	if not mod_action.run(&"items.remove.selected", {}): # Cleanup
		return false
	return true

## Creates a single item, give it a property, then delete the property \
## without deleting the whole item
func test4() -> bool:
	# Setup: --------------------------------------------------
	if not mod_action.run(&"items.append.items", {}):
		return false
	if not mod_action.run(&"items.stage.unordered", {
		"item": mod_item.unordered_items }):
			return false
	if not mod_action.run(&"items.select.by_item_index", {
		"item_idx": [0] }):
			return false
	var __display: Display = Display.new("coc");
	var __selected_id: String = mod_item.selected_items[0].id
	if not mod_action.run(&"items.append.properties_to_selected", {
		"properties": [Link.new(__selected_id), __display] }):
			return false
	if not mod_action.run(&"items.remove.property_id", {
		"item": mod_item.selected_items, 
		"property_id": [__display.id] }):
			return false
	# Cleanup: ------------------------------------------------
	if not mod_action.run(&"items.remove.selected", {}):
		return false
	return true

## Create an item and retrieves it as if only ID was known.\
## This can't be done using actions. The UI handles retrieval of items.
#func test5() -> bool:
	#var __id: int = randi() % 100
	#var __item: Item = Item.new(__id)
	#if not manager.append_items([__item]):
		#return false
	#var __get_item: Array[Item] = manager.get_item_by_id([__id])
	#if __get_item.is_empty() or __get_item[0] == null:
		#return false
	#if not manager.remove_items_unordered_index([0]): #      CLEANUP
		#return false
	#return true

## Create an item with a parameter and validly links to itself with \
## a link parameter
func test6() -> bool:
	var __param: Parameter = Parameter.new(Parameter.ParameterTypes.NUMBER)
	if not mod_action.run(&"items.append.items", {
		"properties": [Display.new("Kek"), __param] }):
			return false
	if not mod_action.run(&"items.stage.unordered", {
		"item": mod_item.unordered_items }):
			return false
	if not mod_action.run(&"items.select.by_item_index", {
		"item_idx": [0] }):
			return false
	var __selected_id: String = mod_item.selected_items[0].id
	if not mod_action.run(&"items.append.properties_to_selected", {
		"properties": [Link.new(__selected_id, "", {__param.id: 7}), 
					   Descriptor.new("test")] }):
			return false
	if not mod_action.run(&"items.remove.selected", {}): # Cleanup
		return false
	return true

## Create an item with a parameter and validly links to itself with \
## a link parameter, then queries it.
#func test6_5() -> bool:
	#var __id: int = randi() % 100
	#var __param: Parameter = Parameter.new(Parameter.ParameterTypes.NUMBER)
	#var __item: Item = Item.new(__id, [
		#Display.new("Fodendo"),
		#__param
	#])
	#__item.append_properties([
		#Link.new([__item.id], {__param.id: 7}),
		#Descriptor.new("test")
	#])
	#if not manager.append_items([__item]):
		#return false
	#
	#var __q: Query = Query.new("test", manager.unordered_items, \
			#manager.descriptors_cx, manager.parameters_cx, manager.links_cx)
	#if not __q.parse_raw():
		#return false
	#__q.compute()
	#var __q_result: Array[Item] = await __q.done
	#return true


func do_tests() -> Array[int]:
	var __failed_at: Array[int] = []
	if not test1(): __failed_at.append(1)
	if not test2(): __failed_at.append(2)
	if not test3(): __failed_at.append(3)
	if not test4(): __failed_at.append(4)
	#if not test5(): __failed_at.append(5) #
	if not test6(): __failed_at.append(6)
	#if not await test6_5(): __failed_at.append(65) #
	return __failed_at
