# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# KeyboardModifiers.gd
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

@export var is_shift_modifier: bool = false
@export var is_alt_modifier: bool = false

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return
	#print_debug(event as InputEventKey)
	is_shift_modifier = event.is_action_pressed("shift_mod")
	is_alt_modifier = event.is_action_pressed("alt_mod")
