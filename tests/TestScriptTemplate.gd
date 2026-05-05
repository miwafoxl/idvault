# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# TestScriptTemplate.gd
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

extends Object
var procedures: Array[Callable] = []

## Describe a test here
func run(__mod_item: ItemModule, __mod_action: ActionModule) -> int:
	#region PROCEDURES
	procedures = []
	print("Populate the procedures array with callables that return bool.")
	#endregion PROCEDURES
	#region CALL PROCEDURES
	for i in procedures.size():
		var __call: Callable = procedures[i]
		if not __call.call():
			return i
	#endregion CALL PROCEDURES
	return -1
