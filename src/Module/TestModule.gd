# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# TestModule.gd
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

extends Module
class_name TestModule

@export var enabled: bool
@export var show_time_bench: bool
@export var mod_item: ItemModule
@export var mod_action: ActionModule
@export var tests: Array[Test] = [];
@export var loaded: Dictionary[StringName, Variant] = {}; # {test alias: test ref}
var bench_results: PackedStringArray = []

func append_tests(__tests: Array[Test], __log: bool = false) -> void:
	if __tests.is_empty(): return
	var __loaded_tests: PackedStringArray
	for i: int in __tests.size():
		var __cur: Test = __tests[i]
		var __ref: WeakRef = null
		if __cur.name.is_empty():
			printerr("TestModule: test on index %s has no name. Skipping it." % i)
			continue
		if __cur.name in __loaded_tests:
			printerr("TestModule: test '%s' has the same name as a previously " + \
			"loaded test. Please unload that one then append it." % i)
			continue
		if not __cur.check():
			printerr("TestModule: test '%s' did not pass Test.check()." % __cur.name)
			continue
		__ref = weakref(__cur)
		loaded.set(__cur.name, __ref)
		__loaded_tests.append(__cur.name)
	loaded.sort()
	if __log:
		__loaded_tests.sort()
		print("TestModule: %s loaded:\n- %s" % [__loaded_tests.size(), \
			"\n- ".join(__loaded_tests)
		])

func remove_tests(__rm_tests_aliases: Array[StringName]) -> void:
	if __rm_tests_aliases.is_empty(): return
	for __alias: StringName in loaded.keys():
		if __alias in __rm_tests_aliases:
			loaded.erase(__alias)

func do_tests(__tests: Array[StringName] = loaded.keys()) -> void:
	var __failed: PackedStringArray = []
	if not enabled:
		print("Tests disabled")
		return
	if __tests.is_empty(): return
	for __name: StringName in __tests:
		var __proc_index = run(__name)
		if __proc_index == -1: continue
		__failed.append("'%s' at procedure %s"  % [__name, __proc_index])
	if __failed.is_empty():
		print("TestModule: All tests passed.")
		if show_time_bench:
			print_rich("TestModule: Time Benchmark:\n- %s" % \
			"\n- ".join(bench_results))
	else:
		printerr("TestModule: One or more tests failed:\n- %s" % \
			"\n- ".join(__failed))
	return

func run(__test_name: StringName) -> int:
	var __ref: WeakRef = loaded.get(__test_name, null)
	var __test: Test = null
	if __ref == null:
		printerr("TestModule: test '%s' not found or loaded." % __test_name)
		return false
	__test = __ref.get_ref()
	if __test == null:
		printerr("TestModule: failed to get a reference to test '%s'." % __test_name)
		return false
	
	var __process_trigger: Callable = func(__tr: Trigger, __act: ActionModule) -> void:
		if (__tr == null) or (__tr.relevant_id.is_empty()):
			printerr("TestModule::__process_trigger: Received invalid or null trigger")
			return
		match __tr.type:
			Trigger.TriggerTypes.ACTION:
				__act.run(__tr.relevant_id, __tr.parameters)
			Trigger.TriggerTypes.UI_REQUEST:
				pass
			_:
				printerr("TestModule::__process_trigger: Invalid trigger type '%s'" % \
					Trigger.TriggerTypes.keys()[__tr.type])
	
	var __mod_item: ItemModule = mod_item.duplicate()
	var __mod_action: ActionModule = mod_action.duplicate()
	__mod_action.mod_item = __mod_item
	__mod_item.trigger.connect(__process_trigger.bind(__mod_action))
	__mod_action.trigger.connect(__process_trigger.bind(__mod_action))
	var __timer_2: int = Time.get_ticks_usec()
	var __result: int = __test.execute(__mod_item, __mod_action)
	var __timer_3: int = Time.get_ticks_usec()
	__mod_item.queue_free()
	__mod_action.queue_free()
	var __result_speed: int = (__timer_3 - __timer_2)
	bench_results.append("[color=dark_gray]%s[/color]:\n\t%s µsec\t\t%s ms" % [
		__test_name, 
		__result_speed, __result_speed / 1000.0
	])
	return __result
